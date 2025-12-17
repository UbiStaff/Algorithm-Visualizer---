# Algorithm Visualizer - 算法动画演示

<div align="center">
  <img src="frontend/public/favicon.svg" width="100" height="100" alt="Algorithm Visualizer Logo">
  <h2>Algorithm Visualizer - 算法动画</h2>
  <p>A beautiful and interactive algorithm visualization platform built with Vue 3 and Spring Boot.</p>
  <div style="margin: 10px 0;">
    <a href="README.md" onclick="loadContent('README.md')" style="margin: 0 5px; padding: 5px 10px; background: #0366d6; color: white; text-decoration: none; border-radius: 3px;">English</a>
    <a href="README-zh.md" onclick="loadContent('README-zh.md')" style="margin: 0 5px; padding: 5px 10px; background: #f6f8fa; color: #24292e; text-decoration: none; border-radius: 3px; border: 1px solid #d1d5da;">中文</a>
  </div>
  <div style="margin: 20px 0;">
    <img src="https://img.shields.io/badge/Vue.js-3.x-brightgreen" alt="Vue.js">
    <img src="https://img.shields.io/badge/Spring%20Boot-3.x-blue" alt="Spring Boot">
    <img src="https://img.shields.io/badge/TypeScript-5.x-blueviolet" alt="TypeScript">
    <img src="https://img.shields.io/badge/Maven-3.x-orange" alt="Maven">
    <img src="https://img.shields.io/badge/Vite-7.x-yellow" alt="Vite">
  </div>
  
  <!-- 算法可视化界面效果展示 -->
  <div style="margin: 30px 0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);">
    <img src="frontend/public/screenshot.svg" alt="Algorithm Visualizer Interface" width="800" style="display: block;">
  </div>
  
</div>

<div id="content">
## Overview

Algorithm Visualizer is an interactive platform for visualizing various algorithms, making it easier to understand how they work step by step. This project demonstrates algorithms with smooth animations and detailed explanations.

## Features

- **Interactive Visualization**: Watch algorithms in action with real-time animations
- **Multiple Algorithms**: Support for sorting, searching, tree, and graph algorithms
- **Step-by-Step Execution**: Control the animation speed and pause/resume at any time
- **Visual Feedback**: Color-coded elements to show algorithm progress
- **Responsive Design**: Works on desktop and mobile devices

## Supported Algorithms

### Sorting Algorithms
- Bubble Sort
- Selection Sort
- Insertion Sort
- Merge Sort
- Quick Sort
- Heap Sort

### Searching Algorithms
- Linear Search
- Binary Search

### Tree Algorithms
- Tree Traversal (Pre-order, In-order, Post-order, Level-order)
- Binary Tree Operations

## Tech Stack

### Frontend
- **Framework**: Vue 3 with Composition API
- **Language**: TypeScript
- **Build Tool**: Vite
- **Styling**: CSS3 with modern features

### Backend
- **Framework**: Spring Boot 3
- **Language**: Java 21
- **Build Tool**: Maven
- **API**: RESTful

## Getting Started

### Prerequisites

- Java 21 or higher
- Maven 3.9 or higher
- Node.js 18 or higher
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd algorithm-visualizer
   ```

2. **Start both frontend and backend**
   ```bash
   ./start.command
   ```

3. **Access the application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:8080

### Manual Startup

#### Backend
```bash
cd backend
mvn spring-boot:run
```

#### Frontend
```bash
cd frontend
npm install
npm run dev
```

## Project Structure

```
algorithm-visualizer/
├── backend/              # Spring Boot backend
│   ├── src/main/java/   # Java source code
│   ├── src/main/resources/ # Configuration files
│   └── pom.xml          # Maven configuration
├── frontend/            # Vue 3 frontend
│   ├── src/             # TypeScript source code
│   │   ├── components/  # Vue components
│   │   ├── assets/      # Static assets
│   │   ├── App.vue      # Main application component
│   │   └── main.ts      # Application entry point
│   ├── index.html       # HTML template
│   ├── package.json     # npm dependencies
│   └── vite.config.ts   # Vite configuration
├── docs/                # Project documentation
├── logs/                # Log files
├── start.command        # One-click startup script
└── stop.command         # One-click shutdown script
```

## Usage

1. **Select an algorithm** from the navigation menu
2. **Configure algorithm parameters** (array size, speed, etc.)
3. **Generate input data** or enter custom data
4. **Start the visualization** and watch the algorithm execute
5. **Use controls** to pause, resume, or step through the algorithm
6. **View explanations** of each step

## Development

### Frontend Development

```bash
cd frontend
npm install    # Install dependencies
npm run dev    # Start development server
npm run build  # Build for production
npm run preview # Preview production build
```

### Backend Development

```bash
cd backend
mvn install    # Install dependencies and build
mvn spring-boot:run # Start development server
mvn test       # Run tests
```

## Documentation

- **Requirements Specification**: docs/需求规格说明书.md
- **Architecture Design**: docs/总体设计说明书.md
- **Detailed Design**: docs/详细设计说明书.md
- **API Documentation**: docs/接口文档.md
- **Database Design**: docs/数据库设计文档.md
- **Change Log**: docs/CHANGELOG.md

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Code Style

- Follow the existing code style
- Write clear comments
- Add tests for new features
- Ensure all tests pass before submitting

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by various algorithm visualization tools
- Built for educational purposes
- Thanks to all contributors and supporters

</div>

<script>
// Function to load content from another file
function loadContent(filePath) {
  fetch(filePath)
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.text();
    })
    .then(content => {
      // Replace the current content with the loaded content
      document.body.innerHTML = content;
    })
    .catch(error => {
      console.error('There was a problem loading the content:', error);
    });
}
</script>