// Test setup for Bun test runner
// This file is preloaded before running tests
/* eslint-disable no-undef */

// Set up DOM environment
import { JSDOM } from "jsdom"

const dom = new JSDOM("<!DOCTYPE html><html><body></body></html>", {
  url: "http://localhost:3000",
  pretendToBeVisual: true,
})

// Copy all JSDOM globals to Node globals
Object.assign(global, {
  window: dom.window,
  document: dom.window.document,
  navigator: dom.window.navigator,
  HTMLElement: dom.window.HTMLElement,
  Element: dom.window.Element,
  MutationObserver: dom.window.MutationObserver,
  Node: dom.window.Node,
  NodeList: dom.window.NodeList,
  HTMLCollection: dom.window.HTMLCollection,
  CustomEvent: dom.window.CustomEvent,
  Event: dom.window.Event,
})
