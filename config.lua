return {
  expires=60,
  white_time=300,
  block_time=1,
  verify_times=5,
  guard_uri="\\.php$",
  white_list={
    localhost={
      "^/tz.php",
    }
  }
}
