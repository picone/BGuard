return {
  expires=120,
  white_time=300,
  block_time=300,
  verify_times=5,
  guard_uri="\\.php$",
  white_list={
    localhost={
      "^/tz.php",
    }
  }
}
