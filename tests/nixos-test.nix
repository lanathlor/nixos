{
  pkgs.nixosTest: {
    name = "nixos-test";
    config = {
      # We'll use a subset of the real config for testing
      # but focus on the test-specific requirements.
      imports = [
        # In a real scenario, you might import parts of your host config here.
        # For this demo, we define a minimal config.
        pkgs.nixos.configuration
      ];

      # Add specific packages for testing
      environment.systemPackages = [ pkgs.coreutils pkgs.bash ];

      # Enable the nixos-test module
      nixos.test.enable = true;
    };

    # Assertions to run inside the VM
    testScript = ''
      # Test 1: Check if coreutils is present by checking for 'ls'
      which ls
      
      # Test 2: Check if a specific file exists (example)
      touch /tmp/test-success
      ls /tmp/test-success
    '';
  }
}
