#!/usr/bin/env bats

# Setup function: Runs before every test
setup() {
    # Ensure the script is executable
    chmod +x ../scripts/env_checker.sh
}

# Test 1: Validate that APT repository configuration adds missing repositories
@test "APT repository configuration" {
    # Backup the original sources.list
    cp /etc/apt/sources.list /tmp/sources.list.bak

    # Remove the ParrotSec repository to simulate a missing configuration
    sudo sed -i '/deb https:\/\/deb.parrot.sh\/parrot/d' /etc/apt/sources.list

    # Run the env_checker.sh script
    run ../scripts/env_checker.sh

    # Verify that the ParrotSec repository has been re-added
    grep -q "deb https://deb.parrot.sh/parrot" /etc/apt/sources.list
    [ "$status" -eq 0 ]

    # Restore the original sources.list
    sudo mv /tmp/sources.list.bak /etc/apt/sources.list
}

# Test 2: Ensure that the script installs missing tools (e.g., curl)
@test "Tool installation: curl" {
    # Remove curl if it exists
    sudo apt-get remove -y curl > /dev/null 2>&1

    # Run the env_checker.sh script
    run ../scripts/env_checker.sh

    # Check that curl is installed
    command -v curl > /dev/null
    [ "$status" -eq 0 ]
}

# Test 3: Ensure all required tools are installed
@test "Environment validation for all tools" {
    # Simulate missing tools by removing nmap
    sudo apt-get remove -y nmap > /dev/null 2>&1

    # Run the env_checker.sh script
    run ../scripts/env_checker.sh

    # Check that nmap is installed
    command -v nmap > /dev/null
    [ "$status" -eq 0 ]
}

# Test 4: Ensure the script runs completely without errors
@test "Script completion without errors" {
    # Run the env_checker.sh script
    run ../scripts/env_checker.sh

    # Check the exit status and output
    [ "$status" -eq 0 ]
    [[ "$output" == *"All tools are installed and up to date!"* ]]
}
