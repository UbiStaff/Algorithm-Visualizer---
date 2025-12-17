<template>
  <section class="demo">
    <div class="controls">
      <button class="btn" @click="randomize">随机数组</button>
      <button class="btn primary" @click="buildSteps">生成步骤</button>
      <button class="btn success" :disabled="!steps.length" @click="play">播放</button>
      <button class="btn" :disabled="!steps.length" @click="pause">暂停</button>
      <button class="btn" :disabled="!steps.length" @click="stepForward">单步</button>
      <button class="btn" :disabled="!steps.length || stepIndex<=0" @click="stepBackward">回退</button>
      <label class="speed">
        速度(ms)
        <input type="range" min="50" max="1000" step="50" v-model.number="speedMs" />
        <span class="num num-speed">{{ speedMs }}</span>
      </label>
      <div class="algo-group">
        <span class="algo-label">算法</span>
        <button
          class="algo-btn"
          :class="{ active: algorithm === 'bubble' }"
          @click="chooseAlgo('bubble')"
        >冒泡排序</button>
        <button
          class="algo-btn"
          :class="{ active: algorithm === 'selection' }"
          @click="chooseAlgo('selection')"
        >选择排序</button>
        <button
          class="algo-btn"
          :class="{ active: algorithm === 'insertion' }"
          @click="chooseAlgo('insertion')"
        >插入排序</button>
      </div>
      <label class="counter">
        交换次数
        <span class="num num-counter">{{ swapCounter }}</span>
      </label>
      <span class="info">
        步骤：
        <span class="num">{{ stepIndex }}</span>
        /
        <span class="num">{{ steps.length }}</span>
      </span>
    </div>

    <div class="content">
      <div class="bars fill">
        <div
          v-for="(v,i) in arr"
          :key="i"
          class="bar"
          :style="{ height: `${v}px` }"
          :class="{ compare: isCompare(i), swap: isSwap(i) }"
        >
          <span class="label">{{ v }}</span>
        </div>
      </div>

      <div class="code-panel">
        <div class="code-title">简化伪代码（{{ algorithmLabel }}）</div>
        <div
          v-for="(line, idx) in pseudo"
          :key="idx"
          class="code-line"
          :class="{ active: codeHighlightLine === idx }"
        >
          {{ line }}
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

type Step =
  | { type: 'compare'; i: number; j: number }
  | { type: 'swap'; i: number; j: number }

const N = 20
const arr = ref<number[]>([])
const initial = ref<number[]>([])
const steps = ref<Step[]>([])
const stepIndex = ref(0)
const playing = ref(false)
const speedMs = ref(200)

const highlight = ref<{ i: number; j: number } | null>(null)
const swapPair = ref<[number, number] | null>(null)
// 布局固定为铺满，不再提供选择
const algorithm = ref<'bubble' | 'selection' | 'insertion'>('bubble')
const codeHighlightLine = ref<number | null>(null)
const swapCounter = ref(0)
const swapped = ref(false)

const pseudo = computed(() => {
  if (algorithm.value === 'bubble') {
    return [
      'swapped = true',
      '当 swapped 为真：',
      '  swapped = false',
      '  对 j 从 0 到 n-2：',
      '    如果 左 > 右：',
      '      交换(左, 右)',
      '      swapped = true',
      '      swapCounter++',
    ]
  }
  if (algorithm.value === 'selection') {
    return [
      '对 i 从 0 到 n-2：',
      '  最小下标 = i',
      '  对 j 从 i+1 到 n-1：',
      '    如果 a[j] < a[最小下标]：',
      '      最小下标 = j',
      '  交换(a[i], a[最小下标])',
    ]
  }
  return [
    '对 i 从 1 到 n-1：',
    '  k = i',
    '  j = k - 1',
    '  当 j >= 0 且 a[j] > a[k]：',
    '    交换(a[j], a[k])',
    '    k = j; j = k - 1',
  ]
})

const algorithmLabel = computed(() => {
  if (algorithm.value === 'bubble') return '冒泡排序'
  if (algorithm.value === 'selection') return '选择排序'
  return '插入排序'
})


function isCompare(idx: number) {
  const h = highlight.value
  if (!h) return false
  return idx === h.i || idx === h.j
}

function isSwap(idx: number) {
  const s = swapPair.value
  if (!s) return false
  const [a, b] = s
  return idx === a || idx === b
}

function randomize() {
  const a = Array.from({ length: N }, () => Math.floor(Math.random() * 180) + 40)
  arr.value = a.slice()
  initial.value = a.slice()
  steps.value = []
  stepIndex.value = 0
  highlight.value = null
  swapPair.value = null
  codeHighlightLine.value = null
  swapCounter.value = 0
  swapped.value = false
}

function buildSteps() {
  // 重置数组到初始值，确保新算法的步骤与数组状态一致
  arr.value = initial.value.slice()
  const a = arr.value.slice()
  let s: Step[] = []
  if (algorithm.value === 'bubble') {
    s = buildStepsBubble(a)
  } else if (algorithm.value === 'selection') {
    s = buildStepsSelection(a)
  } else {
    s = buildStepsInsertion(a)
  }
  steps.value = s
  stepIndex.value = 0
  highlight.value = null
  swapPair.value = null
  codeHighlightLine.value = null
  swapCounter.value = 0
  swapped.value = false
}

function buildStepsBubble(a: number[]): Step[] {
  const s: Step[] = []
  for (let i = 0; i < a.length - 1; i++) {
    for (let j = 0; j < a.length - 1 - i; j++) {
      s.push({ type: 'compare', i: j, j: j + 1 })
      const left = a[j]!
      const right = a[j + 1]!
      if (left > right) {
        s.push({ type: 'swap', i: j, j: j + 1 })
        const tmp = left
        a[j] = right
        a[j + 1] = tmp
      }
    }
  }
  return s
}

function buildStepsSelection(a: number[]): Step[] {
  const s: Step[] = []
  for (let i = 0; i < a.length - 1; i++) {
    let minIdx = i
    for (let j = i + 1; j < a.length; j++) {
      s.push({ type: 'compare', i: minIdx, j })
      const candidate = a[j]!
      const curMin = a[minIdx]!
      if (candidate < curMin) {
        minIdx = j
      }
    }
    if (minIdx !== i) {
      s.push({ type: 'swap', i, j: minIdx })
      const tmp = a[i]!
      a[i] = a[minIdx]!
      a[minIdx] = tmp
    }
  }
  return s
}

function buildStepsInsertion(a: number[]): Step[] {
  const s: Step[] = []
  for (let i = 1; i < a.length; i++) {
    let k = i // 当前待插入元素的位置
    let j = k - 1
    while (j >= 0) {
      const aj = a[j]!
      const ak = a[k]!
      if (!(aj > ak)) break
      s.push({ type: 'compare', i: j, j: k })
      s.push({ type: 'swap', i: j, j: k })
      const tmp = aj
      a[j] = ak
      a[k] = tmp
      k = j
      j = k - 1
    }
  }
  return s
}

function applyStep(step: Step) {
  if (step.type === 'compare') {
    highlight.value = { i: step.i, j: step.j }
    swapPair.value = null
    // 高亮伪代码的比较行
    codeHighlightLine.value =
      algorithm.value === 'bubble' ? 4 : algorithm.value === 'selection' ? 3 : 3
  } else if (step.type === 'swap') {
    const { i, j } = step
    // 防御：索引越界时直接跳过
    if (i < 0 || j < 0 || i >= arr.value.length || j >= arr.value.length) {
      return
    }
    // 使用安全索引并显式断言，避免 number | undefined 与 .at 的诊断
    const ai = arr.value[i]!
    const aj = arr.value[j]!
    arr.value[i] = aj
    arr.value[j] = ai
    swapPair.value = [i, j]
    highlight.value = null
    // 交换计数与伪代码高亮
    swapCounter.value += 1
    if (algorithm.value === 'bubble') swapped.value = true
    codeHighlightLine.value =
      algorithm.value === 'bubble' ? 5 : algorithm.value === 'selection' ? 5 : 4
  }
}

function resetToIndex(idx: number) {
  // 回退：重置数组到初始状态，并重放到 idx 之前
  arr.value = initial.value.slice()
  highlight.value = null
  swapPair.value = null
  codeHighlightLine.value = null
  swapCounter.value = 0
  swapped.value = false
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

function pause() {
  playing.value = false
}

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

function chooseAlgo(algo: 'bubble' | 'selection' | 'insertion') {
  // 更新算法并暂停播放，避免并发导致错位
  algorithm.value = algo
  playing.value = false
  // 清空高亮与计数状态
  highlight.value = null
  swapPair.value = null
  codeHighlightLine.value = null
  swapCounter.value = 0
  swapped.value = false
  // 从初始数组重建步骤，确保一致性
  buildSteps()
}

// 初始化一次
randomize()
</script>

<style scoped>
.demo {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.controls {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px 12px;
}
.content {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 16px;
  align-items: start;
}
.btn {
  padding: 6px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
}
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.btn.primary { background: #f5f7ff; border-color: #c7d2fe; }
.btn.success { background: #ecfeff; border-color: #a5f3fc; }
.speed { display: inline-flex; align-items: center; gap: 8px; margin-left: 8px; }
.algo-group { display: inline-flex; align-items: center; gap: 8px; margin-left: 8px; }
.algo-label { color: #64748b; }
.algo-btn { padding: 4px 8px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; cursor: pointer; }
.algo-btn.active { background: #f5f7ff; border-color: #c7d2fe; }
.counter { display: inline-flex; align-items: center; gap: 8px; margin-left: 8px; }
.info { margin-left: 8px; color: #64748b; display: inline-flex; align-items: baseline; gap: 4px; }
.num {
  display: inline-block;
  text-align: right;
  /* 使用表格数字确保每个数字宽度一致 */
  font-variant-numeric: tabular-nums;
  font-feature-settings: 'tnum' 1, 'lnum' 1;
  /* 固定显示宽度为 3 个字符，避免数字变化引起位移 */
  min-width: 3ch;
}
.num-speed { min-width: 4ch; }
.num-counter { min-width: 3ch; }

.bars {
  display: flex;
  align-items: flex-end;
  gap: 6px;
  height: 240px;
  padding: 12px;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
}
.bars.fill { justify-content: space-between; }
.bar {
  width: 22px;
  background: #93c5fd;
  border-radius: 6px 6px 0 0;
  position: relative;
  transition: transform 200ms ease, background 150ms ease;
}
.bar.compare { background: #fde68a; }
.bar.swap { background: #fca5a5; }
.label {
  position: absolute;
  bottom: 4px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 10px;
  color: #0f172a;
}

.code-panel {
  background: #0f172a;
  color: #e2e8f0;
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  border-radius: 8px;
  padding: 12px;
  height: 240px; /* 与柱状图同高，避免页面纵向溢出 */
  overflow: auto;
}
.code-title { font-weight: 600; margin-bottom: 6px; opacity: 0.9; }
.code-line { padding: 4px 8px; border-left: 4px solid transparent; opacity: 0.85; }
.code-line.active { background: #334155; color: #fff; border-left-color: #22c55e; opacity: 1; }
</style>