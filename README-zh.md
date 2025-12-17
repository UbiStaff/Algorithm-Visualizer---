# Algorithm Visualizer - 算法动画演示

<div align="center">
  <img src="frontend/public/favicon.svg" width="100" height="100" alt="Algorithm Visualizer Logo">
  <h2>Algorithm Visualizer - 算法动画</h2>
  <p>A beautiful and interactive algorithm visualization platform built with Vue 3 and Spring Boot.</p>
  <div style="margin: 10px 0;">
    <a href="README.md" onclick="loadContent('README.md')" style="margin: 0 5px; padding: 5px 10px; background: #f6f8fa; color: #24292e; text-decoration: none; border-radius: 3px; border: 1px solid #d1d5da;">English</a>
    <a href="README-zh.md" onclick="loadContent('README-zh.md')" style="margin: 0 5px; padding: 5px 10px; background: #0366d6; color: white; text-decoration: none; border-radius: 3px;">中文</a>
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
    <img src="frontend/public/screenshot.svg" alt="算法可视化界面" width="800" style="display: block;">
  </div>
  
</div>

<div id="content">
## 项目概述

<div align="center">
  <!-- 算法可视化界面效果展示 -->
  <div style="margin: 30px 0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);">
    <img src="frontend/public/screenshot.svg" alt="算法可视化界面" width="800" style="display: block;">
  </div>
</div>

算法动画演示平台是一个交互式的算法可视化工具，通过生动的动画效果帮助用户理解各种算法的工作原理和执行过程。

## 功能特性

- **交互式可视化**：实时动画展示算法执行过程
- **多种算法支持**：排序、搜索、树、图等多种算法
- **分步执行**：可控制动画速度，随时暂停/继续
- **视觉反馈**：使用颜色编码显示算法执行状态
- **响应式设计**：支持桌面和移动设备

## 支持的算法

### 排序算法
- 冒泡排序
- 选择排序
- 插入排序
- 归并排序
- 快速排序
- 堆排序

### 搜索算法
- 线性搜索
- 二分搜索

### 树算法
- 树遍历（前序、中序、后序、层序）
- 二叉树操作

## 技术栈

### 前端
- **框架**：Vue 3 Composition API
- **语言**：TypeScript
- **构建工具**：Vite
- **样式**：现代CSS3

### 后端
- **框架**：Spring Boot 3
- **语言**：Java 21
- **构建工具**：Maven
- **API**：RESTful

## 快速开始

### 前提条件

- Java 21 或更高版本
- Maven 3.9 或更高版本
- Node.js 18 或更高版本
- npm 或 yarn

### 安装与运行

1. **克隆仓库**
   ```bash
   git clone <仓库地址>
   cd algorithm-visualizer
   ```

2. **一键启动前后端**
   ```bash
   ./start.command
   ```

3. **访问应用**
   - 前端：http://localhost:5173
   - 后端API：http://localhost:8080

### 手动启动

#### 后端启动
```bash
cd backend
mvn spring-boot:run
```

#### 前端启动
```bash
cd frontend
npm install
npm run dev
```

## 项目结构

```
algorithm-visualizer/
├── backend/              # Spring Boot后端
│   ├── src/main/java/   # Java源代码
│   ├── src/main/resources/ # 配置文件
│   └── pom.xml          # Maven配置
├── frontend/            # Vue 3前端
│   ├── src/             # TypeScript源代码
│   │   ├── components/  # Vue组件
│   │   ├── assets/      # 静态资源
│   │   ├── App.vue      # 主应用组件
│   │   └── main.ts      # 应用入口
│   ├── index.html       # HTML模板
│   ├── package.json     # npm依赖
│   └── vite.config.ts   # Vite配置
├── docs/                # 项目文档
├── logs/                # 日志文件
├── start.command        # 一键启动脚本
└── stop.command         # 一键停止脚本
```

## 使用说明

1. **从导航菜单选择算法**
2. **配置算法参数**（数组大小、速度等）
3. **生成输入数据**或输入自定义数据
4. **开始可视化**并观察算法执行过程
5. **使用控制按钮**暂停、继续或调整动画速度
6. **查看每一步的解释**

## 开发指南

### 前端开发

```bash
cd frontend
npm install    # 安装依赖
npm run dev    # 启动开发服务器
npm run build  # 构建生产版本
npm run preview # 预览生产构建
```

### 后端开发

```bash
cd backend
mvn install    # 安装依赖并构建
mvn spring-boot:run # 启动开发服务器
mvn test       # 运行测试
```

## 项目文档

- **需求规格说明书**：docs/需求规格说明书.md
- **总体设计说明书**：docs/总体设计说明书.md
- **详细设计说明书**：docs/详细设计说明书.md
- **接口文档**：docs/接口文档.md
- **数据库设计文档**：docs/数据库设计文档.md
- **变更日志**：docs/CHANGELOG.md

## 贡献指南

欢迎贡献代码！请随时提交Pull Request。

### 代码规范

- 遵循现有代码风格
- 编写清晰的注释
- 为新功能添加测试
- 提交前确保所有测试通过

## 许可证

本项目采用MIT许可证 - 详见LICENSE文件。

## 致谢

- 受多种算法可视化工具启发
- 为教育目的而构建
- 感谢所有贡献者和支持者

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