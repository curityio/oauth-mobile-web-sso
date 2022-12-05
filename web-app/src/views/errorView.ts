import {Elements} from './elements';
import {Utils} from './utils';

/*
 * Render errors when required
 */
export class ErrorView {

    public static create() {
        Utils.createContainer(Elements.Error);
    }

    public static render(e: any) {

        const html = `<p style='color:red;'>${e.message}</p>`;
        Utils.setContainerContent(Elements.Error, html);
    }

    public static clear() {

        const html = ``;
        Utils.setContainerContent(Elements.Error, html);
    }
}
