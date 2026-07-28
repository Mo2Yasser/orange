import { createStartHandler, defaultStreamHandler } from "@tanstack/react-start/server";
import { getRouter } from "./router";

const handler = createStartHandler({
  createRouter: getRouter,
  getRouterManifest: () => import("@tanstack/react-start/router-manifest"),
});

export default function(context: { request: Request }) {
  return handler(context, defaultStreamHandler);
}
