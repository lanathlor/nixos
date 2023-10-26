{ mount, bucket }: { lib, pkgs, ... }: {
  systemd.services."s3fs-${bucket}" = {
    description = "DigitalOcean space S3FS";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -m 0500 -pv ${mount}"
        "${pkgs.e2fsprogs}/bin/chattr +i ${mount}"
      ];
      ExecStart = let
        options = [
          "passwd_file=/run/keys/${bucket}"
          "use_path_request_style"
          "allow_other"
          "url=https://fra1.digitaloceanspaces.com"
          "umask=0000"
        ];
      in
        "${pkgs.s3fs}/bin/s3fs ${bucket} ${mount} -f "
          + lib.concatMapStringsSep " " (opt: "-o ${opt}") options;
      ExecStopPost = "-${pkgs.fuse}/bin/fusermount -u ${mount}";
      KillMode = "process";
      Restart = "on-failure";
    };
  };
}
