<?php
if (isset($_GET["msg"])) {
    echo "Reply dari server: " . htmlspecialchars($_GET["msg"]);
} else {
    echo "Tidak ada pesan yang diterima.";
}
?>
