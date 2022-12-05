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
}
