<script setup lang="ts">
useSeoMeta({
  title: 'EHS Fitness — Sua rotina em movimento',
  description: 'Planeje treinos, organize sua alimentação e acompanhe sua evolução em um só lugar.'
})

const benefits = [
  { icon: 'i-lucide-dumbbell', title: 'Treinos que cabem na sua rotina', description: 'Organize exercícios, séries e metas do seu jeito.' },
  { icon: 'i-lucide-utensils', title: 'Alimentação sem complicação', description: 'Registre refeições e tenha clareza sobre suas escolhas.' },
  { icon: 'i-lucide-chart-no-axes-combined', title: 'Evolução que você enxerga', description: 'Acompanhe sua constância e celebre cada avanço.' }
]
</script>

<template>
  <div class="public-page">
    <header class="site-header">
      <NuxtLink
        to="/"
        class="brand"
        aria-label="EHS Fitness, página inicial"
      >
        <span class="brand-mark"><UIcon name="i-lucide-activity" /></span>
        <span>EHS <b>Fitness</b></span>
      </NuxtLink>

      <nav
        class="header-actions"
        aria-label="Navegação principal"
      >
        <a
          href="#como-funciona"
          class="nav-link"
        >Como funciona</a>
        <NuxtLink
          to="/login"
          class="login-link"
        >Entrar</NuxtLink>
        <NuxtLink
          to="/login"
          class="primary-button header-button"
        >Começar agora <UIcon name="i-lucide-arrow-up-right" /></NuxtLink>
      </nav>
    </header>

    <main>
      <section class="hero-section">
        <div class="hero-copy">
          <p class="eyebrow">
            <span /> sua saúde, no seu ritmo
          </p>
          <h1>Uma rotina mais leve.<br><em>Um você mais forte.</em></h1>
          <p class="hero-description">
            Treinos, alimentação e evolução reunidos em um só lugar para transformar pequenos hábitos em grandes resultados.
          </p>
          <div class="hero-actions">
            <NuxtLink
              to="/login"
              class="primary-button"
            >Começar gratuitamente <UIcon name="i-lucide-arrow-right" /></NuxtLink>
            <a
              href="#como-funciona"
              class="text-button"
            >Conhecer a plataforma <UIcon name="i-lucide-play" /></a>
          </div>
          <div class="social-proof">
            <div
              class="avatar-stack"
              aria-hidden="true"
            >
              <span>LM</span><span>JR</span><span>MS</span><span>+</span>
            </div>
            <p><b>Feito para a sua jornada</b><br>começar é o primeiro passo.</p>
          </div>
        </div>

        <div
          class="hero-visual"
          aria-label="Prévia do painel EHS Fitness"
        >
          <div class="sun" /><div class="shape shape-one" /><div class="shape shape-two" />
          <div class="dashboard-card">
            <div class="dashboard-top">
              <span class="mini-brand"><i><UIcon name="i-lucide-activity" /></i> EHS Fitness</span><span class="avatar">A</span>
            </div>
            <p class="dashboard-greeting">
              Olá, Ana <span>✦</span>
            </p>
            <h2>Vamos fazer acontecer?</h2>
            <div class="goal-card">
              <div><span class="goal-icon"><UIcon name="i-lucide-flame" /></span><p>Meta semanal<br><b>3 de 5 treinos</b></p></div><strong>60%</strong>
            </div>
            <div class="progress">
              <span />
            </div>
            <div class="workout-preview">
              <span class="workout-icon"><UIcon name="i-lucide-dumbbell" /></span><div><small>PRÓXIMO TREINO</small><b>Superior · Peito e braços</b><span>45 min · 6 exercícios</span></div><UIcon name="i-lucide-chevron-right" />
            </div>
          </div>
          <div class="floating-card streak-card">
            <span><UIcon name="i-lucide-zap" /></span><p><b>7 dias</b><br>de sequência!</p>
          </div>
          <div class="floating-card nutrition-card">
            <span><UIcon name="i-lucide-apple" /></span><p><b>Alimentação</b><br>no caminho certo</p><UIcon name="i-lucide-check" />
          </div>
        </div>
      </section>

      <section
        id="como-funciona"
        class="benefits-section"
      >
        <p class="eyebrow centered">
          <span /> tudo para evoluir
        </p>
        <h2>Seu bem-estar merece<br>um lugar só dele.</h2>
        <div class="benefit-grid">
          <article
            v-for="benefit in benefits"
            :key="benefit.title"
            class="benefit-card"
          >
            <span class="benefit-icon"><UIcon :name="benefit.icon" /></span>
            <h3>{{ benefit.title }}</h3><p>{{ benefit.description }}</p>
          </article>
        </div>
      </section>
    </main>
  </div>
</template>
