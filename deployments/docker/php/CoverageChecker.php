<?php

declare(strict_types=1);

$inputFile = $argv[1];

$percentageValue = (int)$argv[2];
if ($percentageValue === 0) {
    echo "\033[32mCode coverage is $percentageValue % - OK!\033[m" . PHP_EOL;
    exit(0);
}

$percentage = min(100, max(0, $percentageValue));

if (!file_exists($inputFile)) {
    throw new InvalidArgumentException('Invalid input file provided');
}

if ($percentage === 0) {
    throw new InvalidArgumentException('An integer checked percentage must be given as second parameter');
}

$xml = new SimpleXMLElement(file_get_contents($inputFile));
$metrics = $xml->xpath('//metrics');
$totalElements = 0;
$checkedElements = 0;

foreach ($metrics as $metric) {
    $totalElements += (int)$metric['elements'];
    $checkedElements += (int)$metric['coveredelements'];
}

$coverage = round(($checkedElements / $totalElements) * 100, 2);

if ($coverage < $percentage) {
    echo "\033[31mCode coverage is " . $coverage . "%, which is below the accepted " . $percentage . "%" . "\033[m" . PHP_EOL;
    exit(1);
}

echo "\033[32mCode coverage is " . $coverage . "% - OK!\033[m" . PHP_EOL;

