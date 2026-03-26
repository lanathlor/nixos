# Personal profile for mushu.
# This is the single source of truth for all user-specific data.
# When forking, copy this file and replace all values.
{
  username = "mushu";
  homeDir = "/home/mushu";

  # Generate with: mkpasswd -m yescrypt
  hashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";

  # Filenames (relative to keys/) to authorize for SSH login
  sshKeyFiles = [ "mushu.pub" "id_ed25519.pub" ];

  git = {
    name = "mushu";
    personalEmail = "contact@marieforja.com";
    # GPG key fingerprint for work commit signing (work dir only, not global)
    gpgKey = "F54E5E007F0EE47C1F2F4B2486E1F5832C3882A6";
    # Work directory relative to homeDir — triggers GPG signing
    workDir = "Work/masterMonkeys";
  };
}
