# Ruby on Rails PDF Chatbot

Ruby on Rails PDF Chatbot is a web application that allows users to upload PDF files and interact with a chatbot powered by the OpenAI GPT-3.5 API. Users can upload PDF files, and the application processes them, extracts text, and provides a api to ask questions and receive answers based on the content of the PDFs.

## Features

- User Authentication: Secure user authentication system.
- PDF Upload: Users can upload PDF files.
- PDF Processing: PDF files are processed to extract text content.
- Chatbot API: Interactive chatbot endpoint for querying PDF content.
- OpenAI Integration: Utilizes the OpenAI GPT-3.5 API for natural language understanding.
- Responsive UI: User-friendly and responsive user interface.
- Docker Support: Dockerized for easy deployment.
- Tests: Includes RSpec tests for functionality validation.
- Code Quality: Integrated code quality tools for maintaining codebase.
- API Documentation: Generates API documentation following industry standards.
- Exception Tracking: Exception tracking for monitoring and debugging.

## How to Use

1. Clone this repository.
1. Run `bootstrap.sh` with the name of your project like `./bootstrap.sh --name=my_awesome_project`
2. Set up your environment with the necessary credentials for OpenAI API.
3. Install the required dependencies using `bundle install`.
1. `rspec` and make sure all tests pass
4. Run the Rails server with `rails s`.
5. Access the application in your web browser.

## Docker Support

1. Ensure you have Docker and Docker Compose installed.
2. Clone this repository.
3. Run the `./bootstrap.sh` script with the name of your project and the `-d` or `--for-docker` flag to set up the project for Docker.
4. Generate a secret key for the app using `bin/web rake secret`, and add it to your environment variables.
5. Run tests with `bin/rspec .` to ensure everything is working.
6. Access the application via Docker.

## Code Quality

Run code analysis tools with the following commands:

- `bundle exec rails code:analysis`: Runs various code analysis tools.

## Credits

Ruby on Rails PDF Chatbot was branched off of Rootstrap's [rails_api_base](https://github.com/rootstrap/rails_api_base) project.
