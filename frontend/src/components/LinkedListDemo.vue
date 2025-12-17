<template>
  <section class="demo">
    <div class="controls">
      <div class="controls-row">
        <button class="btn" @click="randomize">随机初始化</button>
        <button class="btn primary" @click="buildSteps" :disabled="isBuildDisabled">生成步骤</button>
        <button class="btn success" :disabled="!steps.length" @click="play">播放</button>
        <button class="btn" :disabled="!steps.length" @click="pause">暂停</button>
        <button class="btn" :disabled="!steps.length" @click="stepForward">单步</button>
        <button class="btn" :disabled="!steps.length || stepIndex<=0" @click="stepBackward">回退</button>
        <label class="speed">
          速度(ms)
          <input type="range" min="50" max="1000" step="50" v-model.number="speedMs" />
          <span class="num num-speed">{{ speedMs }}</span>
        </label>
      </div>

      <div class="controls-row">
        <div class="mode-group">
          <span class="mode-label">模式</span>
          <button class="algo-btn" :class="{ active: mode==='ll' }" @click="setMode('ll')">链表</button>
          <button class="algo-btn" :class="{ active: mode==='stack' }" @click="setMode('stack')">堆栈</button>
          <button class="algo-btn" :class="{ active: mode==='queue' }" @click="setMode('queue')">队列</button>
          <button class="algo-btn" :class="{ active: mode==='dll' }" @click="setMode('dll')">双向链表</button>
        </div>
      </div>

      <div class="controls-row">
        <div class="mode-group">
          <span class="mode-label">操作</span>
          <button class="algo-btn" :class="{ active: currentOp==='search' }" @click="setOp('search')">查找</button>
          <button class="algo-btn" :class="{ active: currentOp==='insertHead' }" @click="setOp('insertHead')">头插</button>
          <button class="algo-btn" :class="{ active: currentOp==='insertTail' }" @click="setOp('insertTail')">尾插</button>
          <button class="algo-btn" :class="{ active: currentOp==='removeHead' }" @click="setOp('removeHead')">删除头</button>
          <button class="algo-btn" :class="{ active: currentOp==='removeTail' }" @click="setOp('removeTail')">删除尾</button>
        </div>
        <label class="val end">
          值
          <input type="number" v-model.number="valueInput" />
        </label>
      </div>
    </div>

    <div class="content">
      <div class="viz" :class="vizClass">
        <template v-if="mode==='stack'">
          <div class="stack">
            <div class="stack-title">Top</div>
            <div v-for="(v,i) in nodes" :key="i" class="node" :class="{ highlight: i===highlightIndex }">
              <span class="value">{{ v }}</span>
            </div>
          </div>
        </template>
        <template v-else-if="mode==='queue'">
          <div class="queue">
            <div class="queue-title">Front</div>
            <div class="nodes">
              <template v-for="(v,i) in nodes" :key="i">
                <div class="node" :class="{ highlight: i===highlightIndex }"><span class="value">{{ v }}</span></div>
                <div v-if="i < nodes.length-1" class="arrow">→</div>
              </template>
            </div>
            <div class="queue-title">Back</div>
          </div>
        </template>
        <template v-else>
          <div class="nodes">
            <template v-for="(v,i) in nodes" :key="i">
              <div class="node" :class="{ highlight: i===highlightIndex }"><span class="value">{{ v }}</span></div>
              <div v-if="i < nodes.length-1" class="arrow">{{ mode==='dll' ? '↔' : '→' }}</div>
            </template>
          </div>
        </template>
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

type Mode = 'll' | 'stack' | 'queue' | 'dll'
type Op = 'init' | 'insertHead' | 'insertTail' | 'removeHead' | 'removeTail' | 'search'
type Step = { type: 'init' } | { type: 'visit'; index: number } | { type: 'advance' } | { type: 'found'; index: number } | { type: 'end' }
  | { type: 'op_init' } | { type: 'mark_index'; index: number | null } | { type: 'apply_op'; value?: number } | { type: 'op_end' }

const mode = ref<Mode>('ll')
const nodes = ref<number[]>([])
const valueInput = ref<number | null>(null)
const highlightIndex = ref<number | null>(null)
const op = ref<Op>('init')
const highlightLine = ref<number | null>(null)
const steps = ref<Step[]>([])
const stepIndex = ref(0)
const playing = ref(false)
const speedMs = ref(200)
const currentOp = ref<'search' | 'insertHead' | 'insertTail' | 'removeHead' | 'removeTail'>('search')
const nodesInitial = ref<number[]>([])
const isBuildDisabled = computed(() => {
  if (currentOp.value === 'search' || currentOp.value === 'insertHead' || currentOp.value === 'insertTail') {
    return valueInput.value == null
  }
  if (currentOp.value === 'removeHead' || currentOp.value === 'removeTail') {
    return nodes.value.length === 0
  }
  return false
})

const vizClass = computed(() => (mode.value === 'stack' ? 'viz-vertical' : 'viz-horizontal'))
const modeLabel = computed(() => (mode.value === 'll' ? '链表' : mode.value === 'stack' ? '堆栈' : mode.value === 'queue' ? '队列' : '双向链表'))

function randomize() {
  const n = Math.floor(Math.random() * 5) + 6
  nodes.value = Array.from({ length: n }, () => Math.floor(Math.random() * 90) + 10)
  nodesInitial.value = nodes.value.slice()
  highlightIndex.value = null
  valueInput.value = null
  op.value = 'init'
  highlightLine.value = null
  steps.value = []
  stepIndex.value = 0
  playing.value = false
}

function setMode(m: Mode) {
  if (mode.value === m) return
  mode.value = m
  highlightIndex.value = null
  op.value = 'init'
  highlightLine.value = null
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  nodesInitial.value = nodes.value.slice()
}

function setOp(o: 'search' | 'insertHead' | 'insertTail' | 'removeHead' | 'removeTail') {
  currentOp.value = o
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  highlightIndex.value = null
  highlightLine.value = null
  nodesInitial.value = nodes.value.slice()
}

function buildOpSteps(): Step[] {
  const s: Step[] = []
  if (currentOp.value === 'insertHead') {
    s.push({ type: 'op_init' })
    s.push({ type: 'mark_index', index: 0 })
    s.push({ type: 'apply_op', value: valueInput.value ?? undefined })
    s.push({ type: 'op_end' })
    return s
  }
  if (currentOp.value === 'insertTail') {
    s.push({ type: 'op_init' })
    s.push({ type: 'mark_index', index: nodes.value.length })
    s.push({ type: 'apply_op', value: valueInput.value ?? undefined })
    s.push({ type: 'op_end' })
    return s
  }
  if (currentOp.value === 'removeHead') {
    s.push({ type: 'op_init' })
    s.push({ type: 'mark_index', index: nodes.value.length ? 0 : null })
    s.push({ type: 'apply_op' })
    s.push({ type: 'op_end' })
    return s
  }
  if (currentOp.value === 'removeTail') {
    s.push({ type: 'op_init' })
    s.push({ type: 'mark_index', index: nodes.value.length ? nodes.value.length - 1 : null })
    s.push({ type: 'apply_op' })
    s.push({ type: 'op_end' })
    return s
  }
  return []
}

function buildSearchSteps(v: number): Step[] {
  const s: Step[] = []
  s.push({ type: 'init' })
  for (let i = 0; i < nodes.value.length; i++) {
    s.push({ type: 'visit', index: i })
    if (nodes.value[i] === v) {
      s.push({ type: 'found', index: i })
      return s
    }
    s.push({ type: 'advance' })
  }
  s.push({ type: 'end' })
  return s
}

function applyStep(step: Step) {
  if (step.type === 'init') {
    op.value = 'search'
    highlightLine.value = 0
    highlightIndex.value = null
    return
  }
  if (step.type === 'visit') {
    op.value = 'search'
    highlightIndex.value = step.index
    highlightLine.value = 2
    return
  }
  if (step.type === 'advance') {
    op.value = 'search'
    highlightLine.value = 3
    highlightIndex.value = null
    return
  }
  if (step.type === 'found') {
    op.value = 'search'
    highlightIndex.value = step.index
    highlightLine.value = 2
    return
  }
  if (step.type === 'end') {
    op.value = 'search'
    highlightIndex.value = null
    highlightLine.value = 4
    return
  }
  if (step.type === 'op_init') {
    op.value = currentOp.value
    highlightLine.value = 0
    highlightIndex.value = null
    return
  }
  if (step.type === 'mark_index') {
    op.value = currentOp.value
    highlightIndex.value = step.index
    highlightLine.value = currentOp.value === 'removeHead' || currentOp.value === 'removeTail' ? 0 : 1
    return
  }
  if (step.type === 'apply_op') {
    op.value = currentOp.value
    if (currentOp.value === 'insertHead') {
      if (step.value != null) nodes.value = [step.value, ...nodes.value]
    } else if (currentOp.value === 'insertTail') {
      if (step.value != null) nodes.value = [...nodes.value, step.value]
    } else if (currentOp.value === 'removeHead') {
      if (nodes.value.length) nodes.value = nodes.value.slice(1)
    } else if (currentOp.value === 'removeTail') {
      if (nodes.value.length) nodes.value = nodes.value.slice(0, -1)
    }
    highlightLine.value = currentOp.value === 'removeHead' || currentOp.value === 'removeTail' ? 1 : 2
    return
  }
  if (step.type === 'op_end') {
    op.value = currentOp.value
    highlightIndex.value = null
    highlightLine.value = null
    return
  }
}

function resetToIndex(idx: number) {
  nodes.value = nodesInitial.value.slice()
  highlightIndex.value = null
  op.value = 'init'
  highlightLine.value = null
  for (let k = 0; k < idx; k++) {
    const s = steps.value[k]
    if (!s) break
    applyStep(s)
  }
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
  resetToIndex(stepIndex.value)
}

function buildSteps() {
  steps.value = []
  stepIndex.value = 0
  playing.value = false
  nodesInitial.value = nodes.value.slice()
  if (currentOp.value === 'search') {
    if (valueInput.value == null) return
    steps.value = buildSearchSteps(valueInput.value)
    highlightLine.value = 0
    return
  }
  steps.value = buildOpSteps()
}

const pseudo = computed(() => {
  if (op.value === 'insertHead') {
    return ['node = new(v)', 'node.next = head', 'head = node']
  }
  if (op.value === 'insertTail') {
    return ['node = new(v)', 'tail.next = node', 'tail = node']
  }
  if (op.value === 'removeHead') {
    return ['if head == null: return', 'head = head.next']
  }
  if (op.value === 'removeTail') {
    return ['if head == null: return', 'prev.next = null', 'tail = prev']
  }
  if (op.value === 'search') {
    return ['cur = head', 'while cur:', '  if cur.val == v: return cur', '  cur = cur.next', 'return null']
  }
  return ['初始化结构', '渲染节点']
})

randomize()
</script>

<style scoped>
.demo { display: flex; flex-direction: column; gap: 16px; }
.controls { display: flex; flex-direction: column; align-items: flex-start; gap: 8px; }
.controls-row { display: flex; flex-wrap: wrap; align-items: center; gap: 8px 12px; margin-bottom: 8px; }
.controls-row:last-child { margin-bottom: 0; }
.btn { padding: 6px 12px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; cursor: pointer; }
.btn.primary { background: #f5f7ff; border-color: #c7d2fe; }
.btn.success { background: #ecfeff; border-color: #a5f3fc; }
.val { display: inline-flex; align-items: center; gap: 8px; margin-left: 8px; }
.val.end { margin-left: auto; }
.speed { display: inline-flex; align-items: center; gap: 8px; margin-left: 8px; }
.num-speed { min-width: 4ch; }
.mode-group { display: inline-flex; align-items: center; gap: 8px; }
.mode-label { color: #64748b; }
.algo-btn { padding: 4px 8px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; cursor: pointer; }
.algo-btn.active { background: #f5f7ff; border-color: #c7d2fe; }
.info { margin-left: 8px; color: #64748b; display: inline-flex; align-items: baseline; gap: 4px; }
.num { font-variant-numeric: tabular-nums; font-feature-settings: 'tnum' 1, 'lnum' 1; min-width: 2ch; display: inline-block; text-align: right; }

.content { display: grid; grid-template-columns: 584px 320px; gap: 16px; align-items: start; width: 100%; }
.viz { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 12px; padding: 12px; height: 240px; display: flex; align-items: center; justify-content: center; width: 100%; max-width: 100%; min-width: 0; overflow: hidden; box-sizing: border-box; }
.viz-horizontal { overflow-x: auto; scrollbar-gutter: stable both-edges; }
.viz-vertical { overflow-y: auto; scrollbar-gutter: stable both-edges; }

.nodes { display: inline-flex; align-items: center; gap: 8px; flex-wrap: nowrap; }
.node { min-width: 42px; height: 42px; background: #93c5fd; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; position: relative; flex-shrink: 0; }
.node.highlight { background: #fde68a; }
.value { font-weight: 600; color: #0f172a; }
.arrow { color: #0f172a; opacity: 0.6; font-size: 18px; }

.stack { display: flex; flex-direction: column-reverse; align-items: center; gap: 8px; }
.stack-title { color: #64748b; }

.queue { display: flex; flex-direction: column; align-items: center; gap: 8px; }
.queue-title { color: #64748b; }

.code-panel { background: #0f172a; color: #e2e8f0; border-radius: 8px; padding: 12px; height: 240px; overflow: auto; font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; box-sizing: border-box; min-width: 0; width: 320px; }
.code-title { font-weight: 600; margin-bottom: 6px; opacity: 0.9; }
.code-line { padding: 4px 8px; border-left: 4px solid transparent; opacity: 0.85; }
.code-line.active { background: #334155; color: #fff; border-left-color: #22c55e; opacity: 1; }
</style>
