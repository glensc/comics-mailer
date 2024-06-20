import { DeliveredState } from "../src/core";
import { expect, test } from "bun:test";

const f = new DeliveredState("state.json");

test("load", async () => {
  expect(await f.load())
    .toBeNil();
});

test("does not have 1 or 3", () => {
  expect(f.has("1"))
    .toBeFalse();
  expect(f.has("3"))
    .toBeFalse();
});

test("has 2", () => {
  f.add("2");
  expect(f.has("2"))
    .toBeTrue();
});

test("store", async () => {
  expect(await f.store())
    .toBeNil();
});


test("has 3, but not store", () => {
  f.add("3");
  expect(f.has("3"))
    .toBeTrue();
});
