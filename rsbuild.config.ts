import { defineConfig } from "@rsbuild/core";

export default {
  html: {
    title: "Gurdwara Display Panels"
  },
  output: {
    copy: [
      // `./src/assets/image.png` -> `./dist/image.png`
      { from: "./src/images", to: "static/images" }
    ]
  }
};
