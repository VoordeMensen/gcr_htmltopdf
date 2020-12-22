
# GCR htmltopdf

Run a [wkhtmltopdf](https://github.com/wkhtmltopdf/wkhtmltopdf)-based PDF generator on Google Cloud Run.

## Getting Started

There seem to be two ways to run reliable HTML to PDF convertors: one is [using headless Chrome and Puppeteer](https://www.ribice.ba/cloud-function-html-to-pdf/). But spinning up a browser, even headless, takes time. This is the other one. This one relies on `wkhtmltopdf` - using WebKit engine. At VoordeMensen we use this one to create tickets for our clients because it's fast. And it supports enough CSS to keep us happy.

### Installing

Create a Cloud Run service with this repo. Consider increasing memory from 265MiB to 1 GiB for improved speed.

### Usage
Simply POST your HTML with variable `html` to `/generate` - optionally separating pages by using the `<page>` tag:

```
<page>This is page one</page>
<page>This goes on a seperate page</page>
```

### Speed
Creating a simple PDF will take about 10 seconds for the very first run, then 5 after GCR has scaled it down to 0 instances. If the instance is still available it runs in about 1800ms. 

Allocating more memory, for instance 1 GiB (instead of standard 256MiB) speeds creation up. 

### Output
The PDF is created and streamed to the browser using https://github.com/mikehaertl/phpwkhtmltopdf - check there for more options

### DIY
Getting wkhtmltopdf running can be a tricky thing. If you want to try for yourself: be sure to include libssl and download the correct release:

```
# install libssl
RUN apt-get -y update
RUN apt-get -y install xvfb build-essential libssl-dev libfontconfig1 libxrender1 fontconfig libjpeg62-turbo xfonts-75dpi xfonts-base

# better wktohtml
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.stretch_amd64.deb 
RUN dpkg -i wkhtmltox_0.12.6-1.stretch_amd64.deb
RUN apt -f install
```

## Acknowledgments

* wkhtmltopdf
* mikehaertl/phpwkhtmltopdf
* voku/simple_html_dom
* sandymadaan/php7.3-docker