<template>
  <section class="demo">
    <div class="controls">
      <div class="controls-row">
        <div class="mode-group">
          <span class="mode-label">模式</span>
          <button class="algo-btn" :class="{ active: mode==='tree' }" @click="setMode('tree')">树</button>
          <button class="algo-btn" :class="{ active: mode==='binary' }" @click="setMode('binary')">二叉树</button>
        </div>
      </div>

      <div class="controls-row">
        <button class="btn" @click="randomize">随机初始化</button>
        <button class="btn" @click="buildSteps" :disabled="false">生成步骤</button>
        <button class="btn success" :disabled="!steps.length" @click="play">播放</button>
        <button class="btn" :disabled="!steps.length" @click="pause">暂停</button>
        <button class="btn" :disabled="!steps.length" @click="stepForward">单步</button>
        <button class="btn" :disabled="!steps.length || stepIndex<=0" @click="stepBackward">回退</button>
        <label class="speed">
          速度(ms)
          <input type="range" min="50" max="1000" step="50" v-model.number="speedMs" />
          <span class="num num-speed">{{ speedMs }}</span>
        </label>
        <div class="mode-group">
          <span class="mode-label">算法</span>
          <button class="algo-btn" :class="{ active: algo==='bfs' }" @click="setAlgo('bfs')">层序遍历</button>
          <button class="algo-btn" :class="{ active: algo==='pre' }" @click="setAlgo('pre')" :disabled="mode!=='binary'">前序</button>
          <button class="algo-btn" :class="{ active: algo==='in' }" @click="setAlgo('in')" :disabled="mode!=='binary'">中序</button>
          <button class="algo-btn" :class="{ active: algo==='post' }" @click="setAlgo('post')" :disabled="mode!=='binary'">后序</button>
          <button class="algo-btn" :class="{ active: algo==='dfs_pre' }" @click="setAlgo('dfs_pre')" :disabled="mode!=='tree'">DFS(前序)</button>
        </div>
      </div>
    </div>

    <div class="dev-notice">
      <div class="dev-title">功能开发中</div>
      <div class="dev-sub">树/二叉树页面正在完善，部分功能待补充</div>
    </div>

    <div class="content">
      <div class="viz" :class="modeClass">
        <div class="tree">
          <div v-for="(lvl, li) in levels" :key="li" class="level">
            <div v-for="n in lvl" :key="n.id" class="node" :class="{ highlight: n.id===highlight }">{{ n.label }}</div>
          </div>
        </div>
      </div>

      <div class="code-panel">
        <div class="code-title">伪代码（{{ modeLabel }}）</div>
        <div v-for="(line, idx) in pseudo" :key="idx" class="code-line" :class="{ active: idx === highlightLine }">{{ line }}</div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

type Mode = 'tree' | 'binary'
type Algo = 'bfs' | 'dfs_pre' | 'pre' | 'in' | 'post'
type Step = { type: 'visit'; id: number }

type TNode = { id: number; label: string; children: number[] }
type BNode = { id: number; label: string; left: number | null; right: number | null }

const mode = ref<Mode>('tree')
const algo = ref<Algo>('bfs')
const steps = ref<Step[]>([])
const stepIndex = ref(0)
const playing = ref(false)
const speedMs = ref(200)
const highlightLine = ref<number | null>(null)
const highlight = ref<number | null>(null)
const tree = ref<TNode[]>([])
const binary = ref<BNode[]>([])
const rootId = ref<number>(0)

const modeLabel = computed(() => (mode.value === 'tree' ? '树' : '二叉树'))
const modeClass = computed(() => (mode.value === 'binary' ? 'viz-vertical' : 'viz-horizontal'))

const levels = computed(() => {
  const lv: Array<Array<{ id: number; label: string }>> = []
  const q: number[] = []
  q.push(rootId.value)
  let idx = 0
  while (q.length) {
    const size = q.length
    const arr: Array<{ id: number; label: string }> = []
    for (let i = 0; i < size; i++) {
      const nid = q.shift() as number
      if (mode.value === 'tree') {
        const n = tree.value.find((x) => x.id === nid)
        if (!n) continue
        arr.push({ id: n.id, label: n.label })
        for (const c of n.children) q.push(c)
      } else {
        const n = binary.value.find((x) => x.id === nid)
        if (!n) continue
        arr.push({ id: n.id, label: n.label })
        if (n.left != null) q.push(n.left)
        if (n.right != null) q.push(n.right)
      }
    }
    lv.push(arr)
    idx++
    if (idx > 6) break
  }
  return lv
})

function setMode(m: Mode) {
  mode.value = m
  algo.value = m === 'tree' ? 'bfs' : 'bfs'
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  highlight.value = null
  highlightLine.value = null
  randomize()
}

function setAlgo(a: Algo) {
  algo.value = a
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  highlight.value = null
  highlightLine.value = null
}

function randomize() {
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  highlight.value = null
  highlightLine.value = null
  if (mode.value === 'tree') {
    const labels = ['A','B','C','D','E','F','G','H']
    const ids = [0,1,2,3,4,5]
    const shuffled = labels.sort(() => Math.random() - 0.5)
    const nodes: TNode[] = [
      { id: 0, label: shuffled[0], children: [1,2,3] },
      { id: 1, label: shuffled[1], children: [4,5] },
      { id: 2, label: shuffled[2], children: [] },
      { id: 3, label: shuffled[3], children: [] },
      { id: 4, label: shuffled[4], children: [] },
      { id: 5, label: shuffled[5], children: [] },
    ]
    tree.value = nodes
    rootId.value = 0
  } else {
    const values = Array.from({ length: 7 }, (_, i) => i + 1)
    const shuffled = values.sort(() => Math.random() - 0.5)
    const nodes: BNode[] = [
      { id: 0, label: String(shuffled[0]), left: 1, right: 2 },
      { id: 1, label: String(shuffled[1]), left: 3, right: 4 },
      { id: 2, label: String(shuffled[2]), left: 5, right: 6 },
      { id: 3, label: String(shuffled[3]), left: null, right: null },
      { id: 4, label: String(shuffled[4]), left: null, right: null },
      { id: 5, label: String(shuffled[5]), left: null, right: null },
      { id: 6, label: String(shuffled[6]), left: null, right: null },
    ]
    binary.value = nodes
    rootId.value = 0
  }
}

function buildSteps() {
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  highlight.value = null
  if (algo.value === 'bfs') {
    steps.value = buildBfs()
    highlightLine.value = 0
    return
  }
  if (mode.value === 'tree') {
    steps.value = buildTreeDfsPre()
    highlightLine.value = 0
    return
  }
  if (algo.value === 'pre') { steps.value = buildBinaryPre(); highlightLine.value = 0; return }
  if (algo.value === 'in') { steps.value = buildBinaryIn(); highlightLine.value = 0; return }
  if (algo.value === 'post') { steps.value = buildBinaryPost(); highlightLine.value = 0; return }
}

function buildBfs(): Step[] {
  const s: Step[] = []
  const q: number[] = []
  q.push(rootId.value)
  while (q.length) {
    const nid = q.shift() as number
    s.push({ type: 'visit', id: nid })
    if (mode.value === 'tree') {
      const n = tree.value.find((x) => x.id === nid)
      if (!n) continue
      for (const c of n.children) q.push(c)
    } else {
      const n = binary.value.find((x) => x.id === nid)
      if (!n) continue
      if (n.left != null) q.push(n.left)
      if (n.right != null) q.push(n.right)
    }
  }
  return s
}

function buildTreeDfsPre(): Step[] {
  const s: Step[] = []
  function dfs(nid: number) {
    s.push({ type: 'visit', id: nid })
    const n = tree.value.find((x) => x.id === nid)
    if (!n) return
    for (const c of n.children) dfs(c)
  }
  dfs(rootId.value)
  return s
}

function buildBinaryPre(): Step[] {
  const s: Step[] = []
  function dfs(nid: number | null) {
    if (nid == null) return
    s.push({ type: 'visit', id: nid })
    const n = binary.value.find((x) => x.id === nid)
    if (!n) return
    dfs(n.left)
    dfs(n.right)
  }
  dfs(rootId.value)
  return s
}

function buildBinaryIn(): Step[] {
  const s: Step[] = []
  function dfs(nid: number | null) {
    if (nid == null) return
    const n = binary.value.find((x) => x.id === nid)
    if (!n) return
    dfs(n.left)
    s.push({ type: 'visit', id: nid })
    dfs(n.right)
  }
  dfs(rootId.value)
  return s
}

function buildBinaryPost(): Step[] {
  const s: Step[] = []
  function dfs(nid: number | null) {
    if (nid == null) return
    const n = binary.value.find((x) => x.id === nid)
    if (!n) return
    dfs(n.left)
    dfs(n.right)
    s.push({ type: 'visit', id: nid })
  }
  dfs(rootId.value)
  return s
}

function applyStep(st: Step) {
  highlight.value = st.id
  if (algo.value === 'bfs') highlightLine.value = 2
  else highlightLine.value = 3
}

async function play() {
  if (!steps.value.length) return
  playing.value = true
  while (playing.value && stepIndex.value < steps.value.length) {
    const s = steps.value[stepIndex.value]
    if (!s) break
    applyStep(s)
    stepIndex.value++
    await new Promise((r) => setTimeout(r, speedMs.value))
  }
  playing.value = false
}

function pause() { playing.value = false }
function stepForward() {
  if (!steps.value.length) return
  if (stepIndex.value < steps.value.length) {
    const s = steps.value[stepIndex.value]
    if (!s) return
    applyStep(s)
    stepIndex.value++
  }
}
function stepBackward() {
  if (stepIndex.value <= 0) return
  stepIndex.value -= 1
  highlight.value = null
  highlightLine.value = 0
  for (let k = 0; k < stepIndex.value; k++) {
    const s = steps.value[k]
    if (!s) break
    applyStep(s)
  }
}

const pseudo = computed(() => {
  if (algo.value === 'bfs') {
    return ['queue=[root]','while queue not empty:','  node=queue.pop()','  visit(node)','  push children to queue']
  }
  if (mode.value === 'tree') {
    return ['dfs(root)','visit(root)','for child in root.children:','  dfs(child)']
  }
  if (algo.value === 'pre') return ['pre(node)','visit(node)','pre(node.left)','pre(node.right)']
  if (algo.value === 'in') return ['in(node)','in(node.left)','visit(node)','in(node.right)']
  return ['post(node)','post(node.left)','post(node.right)','visit(node)']
})
</script>

<style scoped>
.demo { display: flex; flex-direction: column; gap: 16px; }
.controls { display: flex; flex-direction: column; align-items: flex-start; gap: 8px; }
.controls-row { display: flex; flex-wrap: wrap; align-items: center; gap: 8px 12px; }
.btn { padding: 6px 12px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; cursor: pointer; }
.btn.success { background: #ecfeff; border-color: #a5f3fc; }
.speed { display: inline-flex; align-items: center; gap: 8px; margin-left: 8px; }
.num-speed { min-width: 4ch; }
.mode-group { display: inline-flex; align-items: center; gap: 8px; }
.mode-label { color: #64748b; }
.algo-btn { padding: 4px 8px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; cursor: pointer; }
.algo-btn.active { background: #f5f7ff; border-color: #c7d2fe; }

.content { display: grid; grid-template-columns: 1fr 320px; gap: 16px; align-items: start; width: 100%; }
.viz { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 12px; padding: 12px; height: 240px; display: flex; align-items: center; justify-content: center; width: 100%; min-width: 0; box-sizing: border-box; }
.viz-horizontal { overflow-x: auto; }
.viz-vertical { overflow-y: auto; }
.tree { display: flex; flex-direction: column; gap: 8px; }
.level { display: inline-flex; gap: 12px; justify-content: center; }
.node { min-width: 42px; height: 42px; background: #93c5fd; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; flex-shrink: 0; }
.node.highlight { background: #fde68a; }

.code-panel { background: #0f172a; color: #e2e8f0; border-radius: 8px; padding: 12px; height: 240px; overflow: auto; font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; box-sizing: border-box; min-width: 0; }
.code-title { font-weight: 600; margin-bottom: 6px; opacity: 0.9; }
.code-line { padding: 4px 8px; border-left: 4px solid transparent; opacity: 0.85; }
.code-line.active { background: #334155; color: #fff; border-left-color: #22c55e; opacity: 1; }
.dev-notice { background: #fff7ed; border: 1px solid #fdba74; color: #78350f; border-radius: 8px; padding: 12px; }
.dev-title { font-weight: 600; margin-bottom: 4px; }
.dev-sub { font-size: 12px; opacity: 0.85; }
</style>