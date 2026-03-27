# Host configuration

This is a basic template for per-host configuration that needs to be seperated
or you just want to seperate from other hosts without the need for a completly
seperate configuration.

## Quick start tutorial

Follow these four steps

1. Firstly copy the `TEMPLATES/` folder and rename it to your prefered host name
   (this will be used for building the system).

2. Then copy your `hardware-configuration.nix` into this new folder or generate it
   using the command:

   ```sh
   nixos-generate-config --show-hardware-config
   ```

   and copying the output into the file.

3. Then change everything that has a comment with `CHANGEME` next to it and adjust
   some other settings according to your liking (everything with `ADJUSTME`)

4. After that rebuild the system using the command:

   ```sh
   nixos-rebuild switch --flake /path/to/your/config#hostname
   ```
