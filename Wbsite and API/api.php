<?php
header("Content-Type: application/json");

$servername = "localhost";
$username = "******"; //Database login username
$password = "******"; //Database login password
$dbname = "******"; //Database name

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die(json_encode(["error" => $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];
$requestUri = $_SERVER['REQUEST_URI'];
$requestParts = explode('/', trim($requestUri, '/'));
$endpoint = strtolower(array_pop($requestParts));

switch ($method) {
  case 'GET':
    if ($endpoint === 'get') {
      handleGet($conn);
    } else {
      echo json_encode(["error" => "Invalid endpoint"]);
    }
    break;
  case 'POST':
    if ($endpoint === 'post') {
      handlePost($conn);
    } else {
      echo json_encode(["error" => "Invalid endpoint"]);
    }
    break;
  case 'PUT':
    if ($endpoint === 'put') {
      handlePut($conn);
    } else {
      echo json_encode(["error" => "Invalid endpoint"]);
    }
    break;
  case 'DELETE':
    if ($endpoint === 'delete') {
      handleDelete($conn);
    } else {
      echo json_encode(["error" => "Invalid endpoint"]);
    }
    break;
  default:
    echo json_encode(["error" => "Invalid request method"]);
    break;
}

$conn->close();

function handleGet($conn) {
  $sql = "SELECT * FROM posts";
  $result = $conn->query($sql);
  if (!$result) {
    echo json_encode(["error" => $conn->error]);
    return;
  }

  $posts = [];
  while ($row = $result->fetch_assoc()) {
    $posts[] = $row;
  }
  echo json_encode($posts);
}

function handlePost($conn) {
  $data = json_decode(file_get_contents("php://input"), true);
  $title = $conn->real_escape_string($data['title']);
  $content = $conn->real_escape_string($data['content']);
  $sql = "INSERT INTO posts (title, content) VALUES ('$title', '$content')";
  if ($conn->query($sql) === TRUE) {
    echo json_encode(["id" => $conn->insert_id, "title" => $title, "content" => $content]);
  } else {
    echo json_encode(["error" => $conn->error]);
  }
}

function handlePut($conn) {
  $data = json_decode(file_get_contents("php://input"), true);
  $id = $data['id'];
  $title = $conn->real_escape_string($data['title']);
  $content = $conn->real_escape_string($data['content']);
  $sql = "UPDATE posts SET title='$title', content='$content' WHERE id=$id";
  if ($conn->query($sql) === TRUE) {
    echo json_encode(["message" => "Post updated successfully"]);
  } else {
    echo json_encode(["error" => $conn->error]);
  }
}

function handleDelete($conn) {
  parse_str(file_get_contents("php://input"), $data);
  $id = $data['id'];
  if (!empty($id)) {
    $sql = "DELETE FROM posts WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
      echo json_encode(["message" => "Post deleted successfully"]);
    } else {
      echo json_encode(["error" => $conn->error]);
    }
  } else {
    echo json_encode(["error" => "Missing id parameter"]);
  }
}
?>
