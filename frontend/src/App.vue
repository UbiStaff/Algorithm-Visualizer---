<script setup lang="ts">
import { ref } from 'vue'
import BubbleSortDemo from './components/BubbleSortDemo.vue'
import LinkedListDemo from './components/LinkedListDemo.vue'
import TreeDemo from './components/TreeDemo.vue'

const view = ref<'sorting' | 'linkedList' | 'tree'>('sorting')
function setView(v: 'sorting' | 'linkedList' | 'tree') {
  if (view.value === v) return
  view.value = v
}
</script>

<template>
  <div class="app">
    <header class="app__header">
      <h1>Algorithm Visualizer</h1>
      <p class="subtitle">Vue 3 + TypeScript + Vite</p>
      <div class="nav">
        <button class="nav-btn" :class="{ active: view==='sorting' }" @click="setView('sorting')">排序</button>
        <button class="nav-btn" :class="{ active: view==='linkedList' }" @click="setView('linkedList')">链表</button>
        <button class="nav-btn" :class="{ active: view==='tree' }" @click="setView('tree')">树</button>
      </div>
    </header>
    <main class="app__main">
      <BubbleSortDemo v-if="view==='sorting'" />
      <LinkedListDemo v-else-if="view==='linkedList'" />
      <TreeDemo v-else-if="view==='tree'" />
    </main>
  </div>
  
</template>

<style scoped>
.app {
  max-width: 960px;
  margin: 0 auto;
  padding: 24px;
}
.app__header {
  margin-bottom: 16px;
}
.nav { margin-top: 12px; display: inline-flex; gap: 8px; }
.nav-btn { padding: 6px 12px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; cursor: pointer; }
.nav-btn.active { background: #f5f7ff; border-color: #c7d2fe; }
.subtitle {
  color: #64748b;
  margin-top: 4px;
  font-size: 14px;
}
.app__main {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 20px;
}
.placeholder { text-align: center; color: #64748b; padding: 48px 0; }
.ph-title { font-size: 18px; color: #0f172a; margin-bottom: 8px; }
.ph-sub { font-size: 14px; }
</style>
