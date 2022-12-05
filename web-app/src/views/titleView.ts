import {Elements} from './elements';
import {Utils} from './utils';

/*
 * Render a simple title element
 */
export class TitleView {

    public static create() {
        Utils.createContainer(Elements.Title);
    }

    public static render() {

        const html = '<h2>Browser Based App</h2>';
        Utils.setContainerContent(Elements.Title, html);
    }
}