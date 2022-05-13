# Install Homebrew if not exists
which -s brew
if [[ $? != 0 ]]; then
    echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install ruby
which -s rbenv
if [[ $? != 0 ]]; then
    brew install rbenv
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    source ~/.zshrc
fi

echo "N" | rbenv install

# Install bundler
gem install bundler

# Gem
bundle install