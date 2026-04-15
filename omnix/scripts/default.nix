{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "omnix-menu";
      text = builtins.readFile ./omnix-menu.sh;
    })
  ];
}
