// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
import "chartkick/chart.js"
import * as echarts from 'echarts';
import 'echarts/theme/dark';

window.echarts = echarts;
