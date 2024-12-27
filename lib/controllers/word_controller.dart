import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/word.dart';



class WordController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final Rx<Word?> currentWord = Rx<Word?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNextWord();
  }

  Future<void> fetchNextWord() async {
    try {
      isLoading(true);
      final word = await apiService.getNextWord();
      currentWord(word);
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar la siguiente palabra',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> markAsLearned() async {
    if (currentWord.value == null) return;
    
    try {
      isLoading(true);
      await apiService.markWordAsLearned(currentWord.value!.id);
      Get.snackbar(
        'Éxito',
        'Palabra marcada como aprendida',
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchNextWord();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo marcar la palabra como aprendida',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}