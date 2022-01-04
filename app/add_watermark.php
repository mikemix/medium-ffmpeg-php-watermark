<?php

use Symfony\Component\Process\Process;

require __DIR__ . '/vendor/autoload.php';

$conversion = new Process([
    'ffmpeg',
    // overwrite result file
    '-y',
    // input movie
    ...['-i', 'data/sample.mp4'],
    // input watermark
    ...['-i', 'data/medium_logo.png'],
    // fast preset, no compression – keep input movie "as is"
    ...['-preset', 'ultrafast'],
    // control the position of the watermark
    // one have to determine best x and y values for different watermark sizes
    ...['-filter_complex', 'overlay=x=(main_w-overlay_w-20):y=(main_h-overlay_h)/(main_h-overlay_h)+20'],
    // where to store the result
    'data/result.mp4',
]);

$conversion->setTimeout(900.0);
$conversion->start();

foreach ($conversion as $data) {
    echo $data , PHP_EOL;
}
