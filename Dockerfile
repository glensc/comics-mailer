# Used guide at:
# - https://bun.sh/guides/ecosystem/docker

# Use the official Bun image
# See all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1-alpine AS base
WORKDIR /app

# Install dependencies into temp directory
# This will cache them and speed up future builds
FROM base AS install
WORKDIR /deps
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Install with --production (exclude devDependencies)
WORKDIR /runtime
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile --production

# Copy node_modules from temp directory
# Then copy all (non-ignored) project files into the image
FROM base AS prerelease
COPY --from=install /deps/node_modules node_modules/
COPY . .

# [optional] tests
ENV NODE_ENV=production
RUN bun test

# https://bun.sh/docs/bundler/executables
# compile everything to a binary called cli which includes the bun runtime
RUN bun bundle

# Use same base image
# https://github.com/oven-sh/bun/blob/206d2edf126f3e0d1abdce5a581115f60d584ecd/dockerhub/alpine/Dockerfile#L1
FROM alpine:3.20 AS runtime-base
WORKDIR /app

# Setup bun user
# https://github.com/oven-sh/bun/blob/206d2edf126f3e0d1abdce5a581115f60d584ecd/dockerhub/alpine/Dockerfile#L60C1-L65C54
RUN \
    addgroup -g 1000 bun \
    && adduser -u 1000 -G bun -s /bin/sh -D bun \
    && exit 0

# Copy production dependencies and source code into final image
FROM base AS release
# Run the app
USER bun
ENTRYPOINT [ "bun", "run", "start" ]

COPY --from=install /runtime/node_modules node_modules/
COPY --from=prerelease /app/package.json ./
COPY --from=prerelease /app/src/ ./src/
ARG APP_VERSION=unknown
ENV APP_VERSION=$APP_VERSION
