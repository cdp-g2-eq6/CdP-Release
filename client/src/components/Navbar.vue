<template>
  <section>
    <!-- Here go the navbar settings -->
    <b-sidebar
      type="is-light"
      :fullheight="fullheight"
      :overlay="overlay"
      open
    >
      <div class="p-1">
        <!-- Logo -->
        <!-- <img :src="logo" alt="logo"/> -->
        <h1 class="title">{{projectName}}</h1>

        <!-- Menu -->
        <b-menu>
          <b-menu-list label="Menu">
            <b-menu-item
              pack="fas" icon="home" label="Accueil"
              v-on:click="onHomepage">
            </b-menu-item>
            <b-menu-item
              pack="fas" icon="list" label="Backlog"
              v-on:click="onBacklog">
            </b-menu-item>
            <b-menu-item
              pack="fas" icon="tasks" label="Tâches"
              v-on:click="onTasks">
            </b-menu-item>
            <b-menu-item pack="fas" icon="running">
              <template slot="label" slot-scope="props">
                Sprints
                <b-icon class="is-pulled-right"
                        :icon="props.expanded ? 'caret-up' : 'caret-down'">
                </b-icon>
              </template>

              <!-- Here go all the sprints -->
              <b-menu-item v-for="n in sprintNb" v-bind:key="n"
                :label="'Sprint ' + n"
                v-on:click="onSprint($event, n)">
              </b-menu-item>

              <b-menu-item
                pack="fas" icon="plus" label="Ajouter un sprint"
                v-on:click="onNewSprint">
              </b-menu-item>
            </b-menu-item>
          </b-menu-list>

        <!-- Actions -->
        <b-menu-list label="Actions">
            <b-checkbox-button
                true-value="false"
                false-value="true"
                :native-value="checkboxState"
                v-model="editValueChanged"
                size="is-small"
                type="is-primary">
                <b-icon icon="edit"></b-icon>
                <span>Mode édition</span>
            </b-checkbox-button>
        </b-menu-list>
        </b-menu>
      </div>

    </b-sidebar>
  </section>
</template>

<script>
export default {
  props: {
    nbSprints: Number,
    projectName: String,
  },
  data() {
    return {
      logo: 'https://via.placeholder.com/250x150',
      fullheight: true,
      overlay: false,
      sprintNb: 0,
      checkboxState: true, // it will be
      editValueChanged: '', // hack for the watcher to work
    };
  },
  methods: {
    // Called when "Ajouter un sprint" is clicked
    onNewSprint: function(event) {
      this.$buefy.dialog.confirm({
        message: 'Êtes vous sûr d\'ajouter un nouveau sprint?',
        onConfirm: () => {
          this.sprintNb ++;
          this.$emit('onSprintNbChanged', this.sprintNb);
          this.$buefy.toast.open({
            message: `Sprint ${this.sprintNb} ajouté!`,
            type: 'is-primary',
          });
        },
      });
    },
    // Called when "Accueil" is clicked
    onHomepage: function(event) {
      this.redirect('/homepage');
    },
    // Called when "Backlog" is clicked
    onBacklog: function(event) {
      this.redirect('/backlog');
    },
    // Called when "Tâches" is clicked
    onTasks: function(event) {
      this.redirect('/tasks');
    },
    onSprint: function(event, sprintId) {
      this.redirect('/sprint/' + sprintId);
    },
    // Safe redirect call
    redirect: function(path) {
      if (this.$route.path !== path) {
        this.$router.push(path);
      }
    },
  },
  watch: {
    // Called when the edit checkbox changed
    editValueChanged: function(newEdit) {
      this.$emit('onEditChanged', newEdit);
    },
  },
  mounted: function() {
    const self = this;
    this.$nextTick(function() {
      // execute initialization code here (use self as being this)
      self.sprintNb = self.nbSprints;
    });
  },
};
</script>

<style>
.p-1 {
  padding: 1em;
}
</style>