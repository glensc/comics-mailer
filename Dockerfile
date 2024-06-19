# Used guide at:
# - https://bun.sh/guides/ecosystem/docker

# Use the official Bun image
# See all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1 as base
WORKDIR /app

# Install dependencies into temp directory
# This will cache them and speed up future builds
FROM base AS install
WORKDIR /deps
COPY package.json bun.lockb .
RUN bun install --frozen-lockfile

# Install with --production (exclude devDependencies)
WORKDIR /runtime
COPY package.json bun.lockb .
RUN bun install --frozen-lockfile --production

# Copy node_modules from temp directory
# Then copy all (non-ignored) project files into the image
FROM base AS prerelease
COPY --from=install /deps/node_modules node_modules
COPY . .

# [optional] tests
ENV NODE_ENV=production
RUN bun test

# Copy production dependencies and source code into final image
FROM base AS release
# Run the app
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "bun", "run", "start" ]

COPY --from=install /runtime/node_modules node_modules
COPY --from=prerelease /app/package.json .
COPY --from=prerelease /app/src/ ./src/
ARG APP_VERSION=unknown
ENV APP_VERSION=$APP_VERSION
