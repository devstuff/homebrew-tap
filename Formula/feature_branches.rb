# typed: false
# frozen_string_literal: true

class FeatureBranches < Formula
  desc 'Git feature branch management scripts with JIRA/GitHub/GitLab/BitBucket integration'
  homepage 'https://github.com/john.bates/feature-branches'
  # Update url and sha256 when publishing a release tarball.
  # url "https://github.com/john.bates/feature-branches/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "..."
  license 'MIT'
  head 'https://github.com/john.bates/feature-branches.git', branch: 'main'

  # Runtime dependencies (recommended; features degrade gracefully without them).
  depends_on 'bash' => :build          # Requires Bash 4.3+; macOS ships 3.x.
  depends_on 'gh'                      # GitHub CLI (SCM_PROVIDER=github)
  depends_on 'jira-cli'                # JIRA CLI by ankitpokhrel (ISSUE_PROVIDER=jira)
  depends_on 'jq'                      # JSON processing (required)

  # Optional providers (install as needed):
  #   brew install glab               # GitLab CLI (SCM_PROVIDER=gitlab)
  #   brew install bkt                # BitBucket CLI (SCM_PROVIDER=bitbucket)

  def install
    # Install all executable scripts directly to bin/.
    executables = Dir['*'].select { |f| File.executable?(f) && File.file?(f) }
    bin.install(*executables)

    # Install library files alongside scripts (they are sourced by name, not path).
    lib_files = Dir['lib-*.sh']
    bin.install(*lib_files) unless lib_files.empty?

    # Install the example config template.
    doc.install 'dot-feature-branches.example' if File.exist?('dot-feature-branches.example')
  end

  def caveats
    <<~CAVEATS_EOS
      feature-branches requires a .feature-branches config file.

      Create one in your Git repository root (or a parent directory):

        # ~/.feature-branches  (user-wide default)
        ISSUE_PROVIDER=jira       # jira | github | gitlab | none
        SCM_PROVIDER=github       # github | gitlab | bitbucket

        # Optional: suffix for pluggable branch/PR title formatters.
        # FEATURE_FORMAT_SUFFIX=my-employer

      For JIRA, configure jira-cli first:
        jira init

      For GitHub, authenticate gh first:
        gh auth login
    CAVEATS_EOS
  end

  test do
    system "#{bin}/git-default-branch", '--help'
  end
end
