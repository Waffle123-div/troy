<?php
header('Content-Type: application/json');

// Check if the request contains XML data
if (!isset($_POST['xmlData'])) {
    http_response_code(400);
    echo json_encode(['error' => 'No XML data received']);
    exit;
}

$xmlData = $_POST['xmlData'];

// Path to the XML file (assuming it's in the same directory)
$xmlFile = 'students.xml';

try {
    // Validate XML structure
    $doc = new DOMDocument();
    if (!$doc->loadXML($xmlData)) {
        throw new Exception('Invalid XML data');
    }

    // Save the XML data to the file
    if (file_put_contents($xmlFile, $xmlData) === false) {
        throw new Exception('Failed to write to XML file');
    }

    echo json_encode(['success' => true, 'message' => 'XML file updated successfully']);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
?>