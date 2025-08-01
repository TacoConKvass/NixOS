{ config, pkgs, ... } : {
    imports = [ ./../../modules ];
    
    system.stateVersion = "24.05";
    
    environment.etcBackupExtension = ".bak";
}
