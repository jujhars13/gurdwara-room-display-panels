import './index.css';
import { display } from './display';

const content=await display.getContent('screenId', 1);

document.title = `${content.screenNumber}: Display panel`;

const contentDiv=document.createElement('div');
contentDiv.id = 'content';
contentDiv.className = 'content';

contentDiv!.innerHTML = `
  <p id='date'>${content?.date}</p>
  <h1 id='title'>${content.title}</h1>
  <p id='subtitle'>${content?.subtitle}</p>
  <p id='misc'>${content?.misc}</p>
  <p id='time'>${content?.time}</p>
  <div id='time'><a href='${content?.image}'/></div>
`

document.querySelector('#root')!.appendChild(contentDiv);