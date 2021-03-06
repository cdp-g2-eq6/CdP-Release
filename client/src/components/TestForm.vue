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
                :value="test.title"
                v-model="test.title"
                placeholder="Titre de votre Test"
                required>
            </b-input>
          </b-field>

          <b-field label="Description">
            <b-input
                :value="test.description"
                v-model="test.description"
                placeholder="Description de votre Test" required>
            </b-input>
          </b-field>

          <b-field label="Tâche Associée">
             <b-dropdown
                v-model="selectedTask" aria-role="list" scrollable>
                <button class="button is-primary" type="button" slot="trigger">
                  <span>
                    {{ '#' + selectedTask._id + ' ' + selectedTask.title }}
                  </span>
                  <b-icon icon="caret-down"></b-icon>
                </button>

                <div v-for="task in tasks" v-bind:key="task._id">
                  <b-dropdown-item :value="task" aria-role="listitem">
                    <span>{{'#' + task._id + ' ' + task.title}}</span>
                  </b-dropdown-item>
                </div>
            </b-dropdown>
          </b-field>

        </section>
        <footer class="modal-card-foot">
            <button class="button" @click="$emit('close')">
            Annuler
          </button>
          <button
              v-if="!isUpdate()"
              class="button is-primary"
              @click="save();">
            Valider
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
import TestsService from '@/services/TestsService';

export default {
  name: 'TestForm.vue',
  props: {
    modalTitle: {
      type: String,
      required: true,
    },
    test: {
      type: Object,
      required: true,
    },
    tasks: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      selectedTask: this.tasks[0], // will get override when mounted
    };
  },
  methods: {
    isUpdate() {
      if (this.test._id > -1) {
        return true;
      }
      return false;
    },
    async save() {
      const dataForm = {
        title: this.test.title,
        description: this.test.description,
        linkedTask: this.selectedTask._id,
        runs: this.test.runs,
      };
      const loading = this.$buefy.loading.open({container: null});
      try {
        const resp = await TestsService.createTest(dataForm);
        if (resp.data.success) {
          this.$buefy.toast.open(`Test sauvegardée!`);
        } else {
          console.error(resp);
          this.$buefy.toast.open(`Erreur de sauvegarde`);
        }
      } catch (err) {
        console.error(err);
        this.$buefy.toast.open(`Erreur de sauvegarde`);
      }
      loading.close();
      this.$emit('updateTestList');
      this.$emit('close');
    },
    async update() {
      const dataForm = {
        id: this.test._id,
        title: this.test.title,
        description: this.test.description,
        linkedTask: this.selectedTask._id,
        runs: this.test.runs,
      };
      const loading = this.$buefy.loading.open({container: null});
      try {
        const resp = await TestsService.updateTest(dataForm);
        if (resp.data.success) {
          this.$buefy.toast.open(`Test Modifiée!`);
        } else {
          console.error(resp);
          this.$buefy.toast.open(`Erreur de modification`);
        }
      } catch (err) {
        console.error(err);
        this.$buefy.toast.open(`Erreur de modification`);
      }
      loading.close();
      this.$emit('updateTestList');
      this.$emit('close');
    },
    erase() {
      this.$buefy.dialog.confirm({
        title: 'Suppression du test',
        message: 'Confirmez-vous la <b>Suppression</b> de ce test?',
        confirmText: 'Supprimer le test',
        cancelText: 'Annuler',
        type: 'is-danger',
        hasIcon: true,
        onConfirm: async () => {
          this.$buefy.toast.open('Test Supprimée!');
          const loading = this.$buefy.loading.open({container: null});
          try {
            const resp = await TestsService.deleteTest({id: this.test._id});
            if (resp.data.success) {
              this.$buefy.toast.open(`Test supprimée!`);
            } else {
              console.error(resp);
              this.$buefy.toast.open(`Erreur de suppression`);
            }
          } catch (err) {
            console.error(err);
            this.$buefy.toast.open(`Erreur de suppression`);
          }
          loading.close();
          this.$emit('updateTestList');
          this.$emit('close');
        },
      });
    },
  },
  mounted: function() {
    const self = this;
    this.$nextTick(function() {
      for (const task of self.tasks) {
        if (task._id === self.test.linkedTask) {
          self.selectedTask = task;
          break;
        }
      }
    });
  },
};


</script>

<style scoped>
.modal-card {
  min-height: 500px;
}
</style>
