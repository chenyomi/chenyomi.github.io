---
title: About
layout: page
---

<section class="about-profile">
    {% if site.picture %}
        <img class="profile-image" alt="{{ site.title }}" src="{% if site.external-image %}{{ site.picture }}{% else %}{{ site.picture | relative_url }}{% endif %}">
    {% else %}
        <span class="profile-image avatar-text" aria-label="{{ site.title }}">YM</span>
    {% endif %}
    <div>
        <p class="eyebrow">About Me</p>
        <h2>我是一名前端开发工程师，擅长把复杂交互做成可维护、可交付的产品。
            <span class="locale-en">I'm a frontend engineer who turns complex interactions into maintainable, shippable products.</span>
        </h2>
        <p>
            我有 9 年前端开发经验，做过中后台系统、移动端 H5、小程序、App、桌面端、数据可视化、3D 可视化和工业场景相关应用。
            相比只完成页面，我更关注需求拆解、原型设计、技术选型、组件抽象、性能优化和上线交付。
            <span class="locale-en">With 9 years of frontend experience across admin systems, mobile H5, mini programs, apps, desktop apps, data visualization, 3D visualization, and industrial applications — I focus on requirements breakdown, prototyping, tech selection, component abstraction, performance, and delivery — not just page implementation.</span>
        </p>
    </div>
</section>

<section class="portfolio-section compact">
    <h2>我擅长的方向 <span class="locale-en">What I Do Best</span></h2>
    <div class="feature-grid two-columns">
        <article class="feature-card">
            <h3>图形编辑器 / 可视化搭建
                <span class="locale-en">Visual Editors / Dashboard Builders</span>
            </h3>
            <p>围绕画布、拖拽、组件配置、数据源、图表编排和交互状态，设计可扩展的前端编辑体验。
                <span class="locale-en">Designing extensible editing experiences around canvas, drag-and-drop, component configuration, data sources, chart composition, and interaction states.</span>
            </p>
        </article>
        <article class="feature-card">
            <h3>工业级 Web 与 3D 展示
                <span class="locale-en">Industrial Web &amp; 3D Visualization</span>
            </h3>
            <p>使用 Three.js、WebGL 和前端工程能力，将设备、物料、工件状态等信息转成可交互的视觉界面。
                <span class="locale-en">Using Three.js, WebGL, and frontend engineering to turn equipment, materials, and workpiece states into interactive visual interfaces.</span>
            </p>
        </article>
        <article class="feature-card">
            <h3>多端应用
                <span class="locale-en">Multi-platform Apps</span>
            </h3>
            <p>熟悉 Web、H5、小程序、uniapp、Hybrid App、Electron 等多端形态，能处理开发、调试、打包和发布流程。
                <span class="locale-en">Experienced with web, H5, mini programs, uniapp, hybrid apps, and Electron — from development and debugging through build and release.</span>
            </p>
        </article>
        <article class="feature-card">
            <h3>中后台与数据可视化
                <span class="locale-en">Admin Systems &amp; Data Visualization</span>
            </h3>
            <p>熟悉权限、请求封装、文件上传、Socket、地图、万级数据虚拟滚动、图表组件和业务模块沉淀。
                <span class="locale-en">Familiar with permissions, request layers, file uploads, sockets, maps, virtual scrolling at scale, chart components, and reusable business modules.</span>
            </p>
        </article>
    </div>
</section>

<section class="portfolio-section compact">
    <h2>技术关键词 <span class="locale-en">Tech Keywords</span></h2>
    <ul class="skill-cloud">
        <li>Vue 2 / Vue 3</li>
        <li>JavaScript / TypeScript</li>
        <li>Pinia / Vuex</li>
        <li>Three.js</li>
        <li>WebGL</li>
        <li>ECharts</li>
        <li>Canvas</li>
        <li>uniapp</li>
        <li>微信小程序</li>
        <li>Electron</li>
        <li>Element</li>
        <li>Ant Design Vue</li>
        <li>Vuetify</li>
        <li>Tailwind CSS</li>
        <li>MQTT</li>
        <li>CI/CD</li>
    </ul>
</section>

<section class="portfolio-section compact">
    <h2>工作方式 <span class="locale-en">How I Work</span></h2>
    <p>
        我习惯先把问题拆清楚，再决定页面结构、组件边界和数据流。对于需要长期迭代的项目，会优先考虑可维护性和配置能力；
        对于展示型、可视化和图形类项目，会兼顾视觉表现、交互反馈和性能。
        <span class="locale-en">I start by breaking problems down clearly, then decide page structure, component boundaries, and data flow. For long-term projects, maintainability and configurability come first; for visual and graphic work, I balance aesthetics, interaction feedback, and performance.</span>
    </p>
    <p>
        当前主页只展示可公开的项目类型和技术能力，不包含公司名称、客户名称、内部业务数据或真实项目敏感信息。
        <span class="locale-en">This portfolio only shows publicly shareable project types and technical capabilities — no company names, client names, internal business data, or sensitive project details.</span>
    </p>
</section>
