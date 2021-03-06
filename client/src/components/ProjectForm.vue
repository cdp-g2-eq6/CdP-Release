<template>
  <div class="backlogForm">
    <form>
      <div class="modal-card" >
        <header class="modal-card-head">
          <p class="modal-card-title">{{modalTitle}}</p>
        </header>
        <section class="modal-card-body">
          <b-field label="Titre">
            <b-input
                :value="name"
                v-model="name"
                placeholder="Titre du projet"
                required>
            </b-input>
          </b-field>

          <b-field label="Description">
            <b-input
                :value="description"
                v-model="description"
                placeholder="Description du projet" required>
            </b-input>
          </b-field>


          <b-field label="Participants">
            <b-taginput
                v-model="participants"
                ellipsis
                icon="user-tag"
                placeholder="Ajouter des Participants (ex: Alex, John, Paul)"
                aria-close-label="Retirer un Participant">
            </b-taginput>
          </b-field>

        </section>
        <footer class="modal-card-foot">
          <button
              v-if="!isUpdate()"
              class="button is-primary"
              @click="save();">
            Valider
          </button>
          <button class="button" @click="$emit('close')">
            Annuler
          </button>
          <div class="update" v-if="isUpdate()">
            <button
                class="button is-danger"
                @click="erase();">
              Supprimer
            </button>
            <button
                class="button is-warning"
                @click="update();">
              Modifier
            </button>
          </div>
        </footer>
      </div>
    </form>
  </div>
</template>

<script>
import ProjectsService from '@/services/ProjectsService';

export default {
  name: 'ProjectForm.vue',
  props: {
    modalTitle: {
      type: String,
      required: true,
    },
    project: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      name: this.project.name,
      description: this.project.description,
      participants: this.project.participants,
    };
  },
  methods: {
    isUpdate() {
      return this.project._id !== undefined;
    },
    erase() {
      this.$buefy.dialog.confirm({
        title: 'Suppression du projet',
        message: 'Confirmez-vous la <b>Suppression</b> de ce projet?',
        confirmText: 'Supprimer le projet',
        cancelText: 'Annuler',
        type: 'is-danger',
        hasIcon: true,
        onConfirm: async () => {
          this.$buefy.toast.open('projet Supprimée!');
          const loading = this.$buefy.loading.open({container: null});
          try {
            const resp = await ProjectsService.deleteProject(
                {id: this.project._id});
            if (resp.data.success) {
              this.$buefy.toast.open(`Projet supprimé!`);
            } else {
              console.error(resp);
              this.$buefy.toast.open(`Erreur de suppression`);
            }
          } catch (err) {
            console.error(err);
            this.$buefy.toast.open(`Erreur de suppression`);
          }
          loading.close();
          this.$emit('updateProjectList');
          this.$emit('close');
        },
      });
    },
    async save() {
      const dataForm = {
        name: this.name,
        description: this.description,
        participants: this.participants,
      };

      const loading = this.$buefy.loading.open({container: null});
      try {
        const resp = await ProjectsService.createProject(dataForm);
        if (resp.data.success) {
          this.$buefy.toast.open(`Projet sauvegardée!`);
        } else {
          console.error(resp);
          this.$buefy.toast.open(`Erreur de sauvegarde`);
        }
      } catch (err) {
        console.error(err);
        this.$buefy.toast.open(`Erreur de sauvegarde`);
      }
      loading.close();
      this.$emit('updateProjectList');
      this.$emit('close');
    },
    async update() {
      const dataForm = {
        id: this.project._id,
        name: this.name,
        description: this.description,
        participants: this.participants,
      };

      const loading = this.$buefy.loading.open({container: null});
      try {
        dataForm.linkedIssues = this.getIdFromIssues(this.linkedIssues);
        const resp = await ProjectsService.updateProject(dataForm);
        if (resp.data.success) {
          this.$buefy.toast.open(`Projet Modifié!`);
        } else {
          console.error(resp);
          this.$buefy.toast.open(`Erreur de modification`);
        }
      } catch (err) {
        console.error(err);
        this.$buefy.toast.open(`Erreur de modification`);
      }
      loading.close();
      this.$emit('updateProjectList');
      this.$emit('close');
    },
  },
};

</script>

<style scoped>

</style>
