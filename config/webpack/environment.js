const { environment } = require('@rails/webpacker')
    const webpack = require('webpack')
    environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery',
        jquery: 'jquery',
        'window.jQuery': 'jquery',
        Popper: ['popper.js', 'default']
    }))
const HbsLoader = {
    test: /\.handlebars$/,
    loader: 'handlebars-loader'
}
environment.loaders.append('handlebars', HbsLoader)
    module.exports = environment



