import { defineConfig } from "@rsbuild/core";

export default {
  server: {
    port: 3001
  },
  html: {
    title: "Gurdwara Display Panels",
    template: "./src/index.html"

  },
  output: {
    copy: [
      { from: "./src/favicon.ico", to: "" },
      { from: "./src/css", to: "static/css" },
      { from: "./src/images", to: "static/images" }
    ]
  }
};
