(function(){
    window.$docsify.custom_title_options = {
        prefix: '',
        suffix: '',
        separator: '-'
    }
    const plugin = function(hook,vm){
        hook.doneEach(function(){
            const title = document.title;
            document.title = '';
            if (window.$docsify.custom_title_options.prefix) {
                document.title = `${window.$docsify.custom_title_options.prefix}`;
                if (window.$docsify.custom_title_options.separator) {
                    document.title = document.title + ' ' + window.$docsify.custom_title_options.separator;
                }
            }
            document.title += ' ' + title;
            if (window.$docsify.custom_title_options.suffix) {
                if (window.$docsify.custom_title_options.separator) {
                    document.title = document.title + ` ${window.$docsify.custom_title_options.separator} `;
                }
                document.title += window.$docsify.custom_title_options.suffix;
            }
        });
    }
    window.$docsify = window.$docsify || {};
    window.$docsify.plugins = window.$docsify.plugins || [];
    window.$docsify.plugins.push(plugin);
})()