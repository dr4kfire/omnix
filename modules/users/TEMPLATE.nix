{
  # Copy this file and change its contents to add
  # a new user to this config
  config.var = {
    username = "user";
    defaultPassword = "password";

    groups = ["wheel"]; # wheel is sudo

    keyboardLayout = "pl";

    git = {
      username = "user";
      email = "example@email.com";
    };
  };
}
