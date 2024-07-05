import "./index.css";
import { display } from "./display";

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);

let content;
try {
  const source = urlParams.get("source");
  const screen = urlParams.get("screen");

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
document.title = `${content.screenNumber}: Display panel`;

const contentDiv = document.createElement("div");
contentDiv.id = "content";
contentDiv.className = "content";

contentDiv!.innerHTML = `
  <p id='date'>${content?.date}</p>
  <div id='background-image' style='background-image: url(${content?.image});'></div>
  <p id='type'>${content?.type}</p>
  <h1 id='title'>${content?.title}</h1>
  <h2 id='subtitle'>${content?.subtitle}</h2>
  <p id='misc'>${content.misc}</p>
  <p id='time'>${content?.time}</p>
`;

document.querySelector("#root")!.appendChild(contentDiv);
