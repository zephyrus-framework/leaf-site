<?php

declare(strict_types=1);

define('ROOT_DIR', dirname(__DIR__));

require ROOT_DIR . '/vendor/autoload.php';

use App\Models\Core\Application;
use Leaf\BuildCommand;
use Zephyrus\Http\Request;

$app = new Application();
$command = new BuildCommand($app);

// BuildCommand writes a root redirect to dist/index.html by default (docs-only sites).
// This site has a LandingController at `/`, so re-dispatch `/` after the build and
// overwrite the redirect with the real landing HTML.
$command->onPostBuild(function ($result, string $outputDir) use ($app): void {
    [$zephyrusApp, ] = $app->buildForStaticGeneration();
    $request = Request::fromArray('GET', 'http://localhost/');
    $response = $zephyrusApp->handle($request);
    if ($response->status === 200) {
        file_put_contents($outputDir . '/index.html', $response->body);
        echo "  -> landing page rendered to /index.html" . PHP_EOL;
    }
});

exit($command->run());
