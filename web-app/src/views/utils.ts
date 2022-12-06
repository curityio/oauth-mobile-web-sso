//
// Copyright (C) 2022 Curity AB.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import {Elements} from './elements';

/*
 * Utils for updating the view
 */
export class Utils {

    /*
     * Create a container once only
     */
    public static createContainer(elementName: string) {

        const parentSelector = `#${Elements.Root}`;
        const parentElement = document.querySelector(parentSelector);
        if (parentElement) {

            const element = document.querySelector(`#${elementName}`);
            if (!element) {

                const child = document.createElement('div');
                child.id = elementName;
                parentElement.appendChild(child);
            }
        }
    }

    /*
     * Update content, which can happen multiple times
     */
    public static setContainerContent(item: string, html: string): void {

        const itemSelector = `#${item}`;
        const element = document.querySelector(itemSelector);
        if (element) {
            element.innerHTML = html;
        }
    }

    /*
     * Add a hidden iframe to the DOM
     */
    public static createHiddenIframe(): HTMLIFrameElement {

        const element = document.querySelector(`#${Elements.Iframe}`);
        if (element) {
            return element as HTMLIFrameElement;
        }

        const frame = document.createElement('iframe');
        frame.id = Elements.Iframe;
        frame.style.visibility = 'hidden';
        frame.style.position = 'absolute';
        frame.width = '0';
        frame.height = '0';
        document.body.appendChild(frame);
        return frame;
    }

    /*
     * Delete the iframe once finished with it
     */
    public static removeHiddenIframe() {

        const element = document.querySelector(`#${Elements.Iframe}`);
        if (element) {
            document.body.removeChild(element);
        }
    }
}
