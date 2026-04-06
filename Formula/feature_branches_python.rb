# typed: false
# frozen_string_literal: true

class FeatureBranchesPython < Formula
  desc 'Git feature branch management (Python implementation)'
  homepage 'https://github.com/john.bates/feature-branches'
  # Update url and sha256 when publishing a release tarball.
  # url 'https://github.com/john.bates/feature-branches/archive/refs/tags/python-v1.0.0.tar.gz'
  # sha256 '...'
  license 'MIT'
  head 'https://github.com/john.bates/feature-branches.git', branch: 'main'

  depends_on 'python@3.14'
  depends_on 'gh'           # GitHub CLI (SCM_PROVIDER=github)
  depends_on 'jira-cli'     # JIRA CLI by ankitpokhrel (ISSUE_PROVIDER=jira)

  # Optional providers:
  #   brew install glab    # GitLab CLI (SCM_PROVIDER=gitlab)
  #   brew install bkt     # BitBucket CLI (SCM_PROVIDER=bitbucket)

  def install
    # Scripts in feature-branches-python/ are the installable artifacts.
    # The lib/ directory must be co-located with the scripts so that
    # sys.path.insert(0, Path(__file__).parent / 'lib') resolves correctly.
    #
    # Install everything into libexec/ then symlink executables to bin/.
    libexec.install Dir['*']

    # Symlink all executable scripts (no extension, shebang line) into bin/.
    executables = Dir['*'].select do |f|
      File.file?(f) && File.executable?(f) && !f.include?('.')
    end
    executables.each { |f| bin.install_symlink libexec / f }
  end

  def caveats
    <<~CAVEATS_EOS
      feature-branches-python requires a .feature-branches config file.

      Create one in your Git repository root (or a parent directory):

        # ~/.feature-branches  (user-wide default)
        ISSUE_PROVIDER=jira       # jira | github | gitlab | none
        SCM_PROVIDER=github       # github | gitlab | bitbucket

      The Python scripts are co-located with the lib/ directory in:
        #{libexec}

      Scripts call the system Python (#{Formula['python@3.14'].opt_bin}/python3)
      and work correctly from any virtual environment context.
    CAVEATS_EOS
  end

  test do
    system "#{bin}/git-remote-owner-repo", '--help'
  end
end
