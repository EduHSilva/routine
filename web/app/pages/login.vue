<script setup lang="ts">
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const keepConnected = ref(true)
const loading = ref(false)
const errorMessage = ref('')
const config = useRuntimeConfig()

async function submit() {
  errorMessage.value = ''
  if (!email.value.trim() || !password.value) {
    errorMessage.value = 'Preencha seu e-mail e senha para continuar.'
    return
  }
  if (!config.public.apiUrl) {
    errorMessage.value = 'A URL da API não foi configurada.'
    return
  }

  loading.value = true
  try {
    const response = await $fetch<{ data?: { token?: string }, message?: string }>(`${String(config.public.apiUrl).replace(/\/$/, '')}/users/auth/login`, {
      method: 'POST',
      body: { email: email.value.trim(), password: password.value }
    })
    if (!response.data?.token) throw new Error(response.message || 'Não foi possível entrar com estas credenciais.')
    localStorage.setItem('user_token', response.data.token)
    localStorage.setItem('user', JSON.stringify(response.data))
    if (!keepConnected.value) sessionStorage.setItem('session_only', 'true')
    else sessionStorage.removeItem('session_only')
    await navigateTo('/home')
  } catch (error: unknown) {
    const fetchError = error as { data?: { message?: string }, message?: string }
    errorMessage.value = fetchError.data?.message || fetchError.message || 'Não foi possível entrar. Tente novamente.'
  } finally {
    loading.value = false
  }
}

useSeoMeta({ title: 'Entrar — EHS Fitness' })
</script>

<template>
  <main class="login-page">
    <section class="login-aside">
      <NuxtLink
        to="/"
        class="brand inverse"
        aria-label="Voltar para a página inicial"
      ><span class="brand-mark"><UIcon name="i-lucide-activity" /></span><span>EHS <b>Fitness</b></span></NuxtLink>
      <div class="aside-copy">
        <p class="eyebrow light">
          <span /> sua jornada começa aqui
        </p><h1>Cuide de você<br>todos os dias.</h1><p>Tenha seus treinos, refeições e conquistas sempre por perto.</p>
      </div>
      <div class="aside-stat">
        <span class="quote">“</span><p>Não se trata de perfeição. Se trata de aparecer por você.</p><span class="line" />
      </div>
      <div class="aside-orb orb-a" /><div class="aside-orb orb-b" />
    </section>
    <section class="login-panel">
      <div class="mobile-brand">
        <NuxtLink
          to="/"
          class="brand"
        ><span class="brand-mark"><UIcon name="i-lucide-activity" /></span><span>EHS <b>Fitness</b></span></NuxtLink>
      </div>
      <div class="login-content">
        <NuxtLink
          to="/"
          class="back-link"
        ><UIcon name="i-lucide-arrow-left" /> Voltar para o início</NuxtLink>
        <div class="login-heading">
          <h2>Que bom ter você de volta.</h2><p>Entre para continuar construindo sua melhor versão.</p>
        </div>
        <form
          novalidate
          @submit.prevent="submit"
        >
          <label for="email">E-mail</label><div class="input-wrap">
            <UIcon name="i-lucide-mail" /><input
              id="email"
              v-model="email"
              type="email"
              placeholder="seu@email.com"
              autocomplete="email"
              required
            >
          </div>
          <div class="password-label">
            <label for="password">Senha</label><a href="#">Esqueci minha senha</a>
          </div>
          <div class="input-wrap">
            <UIcon name="i-lucide-lock-keyhole" /><input
              id="password"
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Sua senha"
              autocomplete="current-password"
              required
            ><button
              type="button"
              :aria-label="showPassword ? 'Ocultar senha' : 'Mostrar senha'"
              @click="showPassword = !showPassword"
            >
              <UIcon :name="showPassword ? 'i-lucide-eye-off' : 'i-lucide-eye'" />
            </button>
          </div>
          <label class="checkbox-label"><input
            v-model="keepConnected"
            type="checkbox"
          ><span /> Manter-me conectado</label>
          <button
            class="primary-button submit-button"
            type="submit"
            :disabled="loading"
          >
            {{ loading ? 'Entrando...' : 'Entrar na minha conta' }} <UIcon name="i-lucide-arrow-right" />
          </button>
          <p
            v-if="errorMessage"
            class="form-error"
            role="alert"
          >
            {{ errorMessage }}
          </p>
        </form>
        <p class="signup-text">
          Ainda não tem uma conta? <a href="#">Crie gratuitamente</a>
        </p>
      </div>
    </section>
  </main>
</template>
