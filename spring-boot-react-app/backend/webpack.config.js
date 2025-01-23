module.exports = {
  mode: 'development', // or 'production'
  entry: './src/main/js/index.js',
  output: {
    path: __dirname + '/src/main/resources/static',
    filename: 'bundle.js',
  },
  resolve: {
    alias: {
      net: 'net-browserify',  // Add this to resolve 'net' to a browser-compatible version
    },
    fallback: {
      net: require.resolve('net-browserify'),  // Polyfill 'net' for the browser
    },
  },
  externals: {
    net: 'commonjs net',  // Treat 'net' as an external dependency (for Node.js)
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-react'],
          },
        },
      },
    ],
  },
};
