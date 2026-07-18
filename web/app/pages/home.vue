<script setup lang="ts">
type StoredUser = { name?: string, username?: string, email?: string, photo?: string }

const router = useRouter()
const user = ref<StoredUser | null>(null)
const activeTab = ref('Início')

onMounted(() => {
  const token = localStorage.getItem('user_token')
  const storedUser = localStorage.getItem('user')
  if (!token || !storedUser) return router.replace('/login')
  try {
    user.value = JSON.parse(storedUser)
  } catch {
    router.replace('/login')
  }
})

const firstName = computed<string>(() => (user.value?.name || user.value?.username || 'atleta').split(' ')[0] || 'atleta')
const initials = computed(() => firstName.value.slice(0, 1).toUpperCase())

function logout() {
  localStorage.removeItem('user_token')
  localStorage.removeItem('user')
  sessionStorage.removeItem('session_only')
  router.push('/login')
}

useSeoMeta({ title: 'Início — EHS Fitness' })
</script>

<template>
  <div class="app-shell">
    <aside class="app-sidebar">
      <NuxtLink to="/home" class="brand app-brand"><span class="brand-mark"><UIcon name="i-lucide-activity" /></span><span>EHS <b>Fitness</b></span></NuxtLink>
      <nav class="app-nav" aria-label="Navegação do aplicativo">
        <button v-for="item in [{ label: 'Início', icon: 'i-lucide-house' }, { label: 'Alimentação', icon: 'i-lucide-utensils' }, { label: 'Treinos', icon: 'i-lucide-dumbbell' }]" :key="item.label" :class="{ active: activeTab === item.label }" @click="activeTab = item.label"><UIcon :name="item.icon" /> {{ item.label }}</button>
      </nav>
      <div class="sidebar-bottom"><button><UIcon name="i-lucide-settings-2" /> Configurações</button><button @click="logout"><UIcon name="i-lucide-log-out" /> Sair</button></div>
    </aside>

    <main class="app-main">
      <header class="app-topbar"><div><p>SEU PAINEL DE BEM-ESTAR</p><h1>Olá, {{ firstName }} <span>👋</span></h1></div><div class="topbar-actions"><button class="round-button" aria-label="Notificações"><UIcon name="i-lucide-bell" /></button><button class="profile-button" aria-label="Perfil"><img v-if="user?.photo" :src="user.photo" alt=""><span v-else>{{ initials }}</span></button></div></header>

      <section class="welcome-card"><div><p>SEU FOCO DE HOJE</p><h2>Pequenos passos<br>também levam longe.</h2><button class="light-button" @click="activeTab = 'Treinos'">Ver treino de hoje <UIcon name="i-lucide-arrow-right" /></button></div><UIcon name="i-lucide-sparkles" class="welcome-icon" /></section>

      <section class="overview-grid" aria-label="Resumo diário"><article><span class="metric-icon blue"><UIcon name="i-lucide-flame" /></span><p>CALORIAS</p><strong>1.240 <small>/ 2.100 kcal</small></strong><div class="metric-track"><span style="width: 59%" /></div></article><article><span class="metric-icon teal"><UIcon name="i-lucide-droplets" /></span><p>ÁGUA</p><strong>1,5 <small>/ 2,5 L</small></strong><div class="metric-track teal-track"><span style="width: 60%" /></div></article><article><span class="metric-icon orange"><UIcon name="i-lucide-dumbbell" /></span><p>MOVIMENTO</p><strong>32 <small>/ 45 min</small></strong><div class="metric-track orange-track"><span style="width: 71%" /></div></article></section>

      <section class="content-grid"><div><div class="section-heading"><div><p>SEU PLANO</p><h2>Próximo treino</h2></div><button class="link-button" @click="activeTab = 'Treinos'">Ver todos <UIcon name="i-lucide-arrow-right" /></button></div><article class="workout-card"><div class="workout-image"><UIcon name="i-lucide-dumbbell" /></div><div class="workout-info"><span>HOJE · 18:00</span><h3>Superior · Peito e braços</h3><p><UIcon name="i-lucide-clock-3" /> 45 min <i /> <UIcon name="i-lucide-list-checks" /> 6 exercícios</p></div><button class="start-button" aria-label="Iniciar treino"><UIcon name="i-lucide-play" /></button></article></div><div class="weekly-card"><div class="section-heading"><div><p>CONSISTÊNCIA</p><h2>Meta semanal</h2></div><strong>3 <small>/ 5</small></strong></div><div class="week-days"><span class="done">S</span><span class="done">T</span><span class="done">Q</span><span class="today">Q</span><span>S</span><span>S</span><span>D</span></div><p>Você está indo muito bem. Continue assim!</p></div></section>
    </main>
  </div>
</template>
