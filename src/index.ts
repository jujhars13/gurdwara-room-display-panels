import "./index.css";
import { display } from "./display";
import { eventType } from "./eventType";

// Get screen and source from GET params in the URL - set defaults if not passed in
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const source = urlParams.get("source")
  ? urlParams.get("source")
  : "2PACX-1vTyKxo6YZo0vBJ1Z0ZXItkC1IEs4I8B8Xc178KcSW461qwxfnEyzqcXuU_cY1iVc3ShNPW3oQYPFFrz";
const screen = urlParams.get("screen") ? urlParams.get("screen") : "1";

let content;
try {
  if (source !== null && screen !== null) {
    content = await display.getContent(source, parseInt(screen));
  } else {
    throw new Error("source or screenId not passed in");
  }
} catch (e) {
  console.error(e);
}
if (!content) {
  content = {
    screenNumber: 0,
    title: "No content available",
    date: new Date().toLocaleDateString()
  };
}
document.title = `${content?.screenNumber}: Display panel`;

const contentDiv = document.createElement("div");
contentDiv.id = "content";
contentDiv.className = "content";

// use image if supplied, otherwise use default image
const imageElement = document.createElement("div");
imageElement.id = "background-image";
// if no image has been sent
let image = eventType["default"].images[0];
if (content?.image) {
  image = content.image;
} else {
  const randomIndex = Math.floor(
    Math.random() * eventType[`${content?.type}`].images.length
  );
  image = eventType[`${content?.type}`].images[randomIndex];
}
imageElement.style.backgroundImage = `url(${image})`;

contentDiv!.innerHTML = `
  <p id='date'>${content?.date}</p>
  ${imageElement.outerHTML}
  <div id="typing-effect-container"><p id='eventType'>${content?.eventType}</p></div>
  <h1 id='title' class='typing-effect'>${content?.title}</h1>
  <h2 id='subtitle'>${content?.subtitle}</h2>
  <p id='misc'>${content.misc}</p>
  <p id='time'>${content?.time}</p>
`;

document.querySelector("#root")!.appendChild(contentDiv);
