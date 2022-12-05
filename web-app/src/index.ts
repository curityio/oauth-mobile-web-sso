class App {

    public async execute(): Promise<void> {
        this.setTitle();
    }

    private setTitle() {

        this.createDiv('#root', 'title');
        const html = '<h2>Browser Based App</h2>';
        this.setHtml('#title', html);

    }

    private createDiv(parentSelector: string, elementName: string) {

        const parent = document.querySelector(parentSelector);
        if (parent) {

            const element = document.querySelector(`#${elementName}`);
            if (!element) {

                const child = document.createElement('div');
                child.id = elementName;
                parent.appendChild(child);
            }
        }
    }

    private setHtml(selector: string, html: string): void {

        const element = document.querySelector(selector);
        if (element) {
            element.innerHTML = html;
        }
    }
}

const app = new App();
app.execute();
