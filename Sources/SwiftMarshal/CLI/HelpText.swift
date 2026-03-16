enum HelpText {

    static var usage: String {
        """
        USAGE: swift-marshal <command> [options] [<files>...]

        COMMANDS:
          check   Analyze Swift files and report structural order
          fix     Reorder members in Swift files
          init    Create a default .swift-marshal.yaml configuration file

        OPTIONS (check):
          -p, --path <dir>     Directory to recursively search for Swift files
          -c, --config <file>  Path to configuration file
          -q, --quiet          Only show files that need reordering
              --warn-only      Exit with code 0 even if files need reordering
              --xcode          Output warnings in Xcode-compatible format
              --output <file>  Write a marker file after execution

        OPTIONS (fix):
          -p, --path <dir>     Directory to recursively search for Swift files
          -c, --config <file>  Path to configuration file
              --dry-run        Show changes without modifying files
          -q, --quiet          Only show summary

        OPTIONS (init):
              --force          Overwrite existing configuration file

        GLOBAL:
              --version        Show version information
          -h, --help           Show this help message
        """
    }
}
