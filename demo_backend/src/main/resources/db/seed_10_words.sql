-- Seed each book with 30 real practice words.
-- The frontend uses these words in groups of 10 per practice round.
-- Safe to execute repeatedly.

SET NAMES utf8mb4;
USE words_demo;

UPDATE books
SET total_words = 30
WHERE id IN (1, 2, 3);

DELETE FROM words
WHERE book_id IN (1, 2, 3)
   OR difficulty = 'API';

INSERT INTO words (
  id, book_id, word, phonetic, meaning, memory_tip,
  example_text, translation_text, answer, difficulty
)
VALUES
  (1, 1, 'abandon', '/əˈbændən/', '放弃；抛弃', '常见搭配 abandon a plan，表示放弃计划。', 'Do not abandon your daily plan.', '不要放弃你的每日计划。', '放弃；抛弃', '四级核心词'),
  (2, 1, 'benefit', '/ˈbenɪfɪt/', '益处；有益于', '既可以作名词，也可以作动词。', 'Reading aloud can benefit your memory.', '朗读有助于记忆。', '益处；有益于', '四级核心词'),
  (3, 1, 'improve', '/ɪmˈpruːv/', '提高；改善', '常见搭配 improve efficiency，表示提高效率。', 'Practice can improve your speaking skills.', '练习能提高你的口语能力。', '提高；改善', '四级核心词'),
  (4, 1, 'common', '/ˈkɒmən/', '常见的；普通的', 'common mistake 表示常见错误。', 'This is a common mistake in writing.', '这是写作中的常见错误。', '常见的；普通的', '四级核心词'),
  (5, 1, 'increase', '/ɪnˈkriːs/', '增加；增长', '可作动词或名词，注意重音变化。', 'The number of learners continues to increase.', '学习者数量持续增加。', '增加；增长', '四级核心词'),
  (6, 1, 'reduce', '/rɪˈdjuːs/', '减少；降低', '常见搭配 reduce pressure，表示减轻压力。', 'Good planning can reduce stress.', '好的计划可以减轻压力。', '减少；降低', '四级核心词'),
  (7, 1, 'support', '/səˈpɔːt/', '支持；支撑', 'support an idea 表示支持一个观点。', 'Evidence can support your opinion.', '证据可以支持你的观点。', '支持；支撑', '四级核心词'),
  (8, 1, 'detail', '/ˈdiːteɪl/', '细节；详细说明', 'pay attention to details 表示注意细节。', 'Please check every detail before submitting.', '提交前请检查每个细节。', '细节；详细说明', '四级核心词'),
  (9, 1, 'review', '/rɪˈvjuː/', '复习；回顾', 'review words 表示复习单词。', 'You should review new words every day.', '你应该每天复习新单词。', '复习；回顾', '四级核心词'),
  (10, 1, 'choice', '/tʃɔɪs/', '选择；选项', 'make a choice 表示做出选择。', 'The right choice saves time.', '正确的选择能节省时间。', '选择；选项', '四级核心词'),

  (11, 2, 'allocate', '/ˈæləkeɪt/', '分配；拨出', '常和 time、resource、budget 搭配。', 'We should allocate more time to review.', '我们应该分配更多时间复习。', '分配；拨出', '六级核心词'),
  (12, 2, 'adequate', '/ˈædɪkwət/', '足够的；适当的', 'adequate preparation 表示充分准备。', 'Adequate sleep helps concentration.', '充足睡眠有助于集中注意力。', '足够的；适当的', '六级核心词'),
  (13, 2, 'approach', '/əˈprəʊtʃ/', '方法；接近', 'an effective approach 表示有效方法。', 'This approach works well for vocabulary learning.', '这种方法很适合词汇学习。', '方法；接近', '六级核心词'),
  (14, 2, 'complex', '/ˈkɒmpleks/', '复杂的', 'complex problem 表示复杂问题。', 'The text explains a complex idea clearly.', '这篇文章清楚解释了一个复杂观点。', '复杂的', '六级核心词'),
  (15, 2, 'confirm', '/kənˈfɜːm/', '确认；证实', 'confirm information 表示确认信息。', 'Please confirm the answer before you submit.', '提交前请确认答案。', '确认；证实', '六级核心词'),
  (16, 2, 'contrast', '/ˈkɒntrɑːst/', '对比；差异', 'in contrast 表示相比之下。', 'The chart shows a clear contrast.', '图表显示出明显对比。', '对比；差异', '六级核心词'),
  (17, 2, 'efficient', '/ɪˈfɪʃnt/', '高效的', 'efficient method 表示高效方法。', 'An efficient plan can improve learning.', '高效计划能提升学习效果。', '高效的', '六级核心词'),
  (18, 2, 'factor', '/ˈfæktə/', '因素；要素', 'key factor 表示关键因素。', 'Motivation is an important factor in study.', '动力是学习中的重要因素。', '因素；要素', '六级核心词'),
  (19, 2, 'indicate', '/ˈɪndɪkeɪt/', '表明；指出', 'indicate that 表示表明某事。', 'The results indicate steady progress.', '结果表明进步稳定。', '表明；指出', '六级核心词'),
  (20, 2, 'strategy', '/ˈstrætədʒi/', '策略；计划', 'learning strategy 表示学习策略。', 'A clear strategy makes review easier.', '清晰策略让复习更容易。', '策略；计划', '六级核心词'),

  (21, 3, 'empirical', '/ɪmˈpɪrɪkəl/', '经验主义的；实证的', '学术文章中常见，表示基于实验或观察。', 'The paper provides empirical evidence.', '论文提供了实证证据。', '经验主义的；实证的', '考研核心词'),
  (22, 3, 'analyze', '/ˈænəlaɪz/', '分析', 'analyze data 表示分析数据。', 'We need to analyze the structure of the passage.', '我们需要分析文章结构。', '分析', '考研核心词'),
  (23, 3, 'concept', '/ˈkɒnsept/', '概念；观念', 'basic concept 表示基本概念。', 'The concept appears often in academic writing.', '这个概念常出现在学术写作中。', '概念；观念', '考研核心词'),
  (24, 3, 'derive', '/dɪˈraɪv/', '获得；源于', 'derive from 表示来源于。', 'Many words derive from Latin.', '许多单词源于拉丁语。', '获得；源于', '考研核心词'),
  (25, 3, 'establish', '/ɪˈstæblɪʃ/', '建立；确立', 'establish a theory 表示确立理论。', 'Researchers established a new model.', '研究者建立了一个新模型。', '建立；确立', '考研核心词'),
  (26, 3, 'interpret', '/ɪnˈtɜːprɪt/', '解释；理解', 'interpret evidence 表示解释证据。', 'Students should interpret the sentence carefully.', '学生应仔细理解这个句子。', '解释；理解', '考研核心词'),
  (27, 3, 'logical', '/ˈlɒdʒɪkl/', '合乎逻辑的', 'logical connection 表示逻辑联系。', 'A logical argument is easier to follow.', '有逻辑的论证更容易理解。', '合乎逻辑的', '考研核心词'),
  (28, 3, 'perspective', '/pəˈspektɪv/', '观点；视角', 'from a different perspective 表示从不同视角。', 'The author offers a new perspective.', '作者提供了一个新视角。', '观点；视角', '考研核心词'),
  (29, 3, 'significant', '/sɪɡˈnɪfɪkənt/', '重要的；显著的', 'significant change 表示显著变化。', 'The study shows significant improvement.', '研究显示出显著提升。', '重要的；显著的', '考研核心词'),
  (30, 3, 'theory', '/ˈθɪəri/', '理论；学说', 'theory and practice 表示理论与实践。', 'The theory explains the result well.', '该理论很好地解释了结果。', '理论；学说', '考研核心词');

INSERT INTO words (
  id, book_id, word, phonetic, meaning, memory_tip,
  example_text, translation_text, answer, difficulty
)
VALUES
  (31, 1, 'create', '/kriˈeɪt/', '创造；创建', 'create a habit 表示养成习惯。', 'You can create a better study habit.', '你可以养成更好的学习习惯。', '创造；创建', '四级核心词'),
  (32, 1, 'decide', '/dɪˈsaɪd/', '决定', 'decide to do 表示决定做某事。', 'She decided to review ten words today.', '她决定今天复习十个单词。', '决定', '四级核心词'),
  (33, 1, 'develop', '/dɪˈveləp/', '发展；培养', 'develop skills 表示培养技能。', 'Reading helps develop language ability.', '阅读有助于培养语言能力。', '发展；培养', '四级核心词'),
  (34, 1, 'effect', '/ɪˈfekt/', '影响；效果', 'have an effect on 表示对某事有影响。', 'Sleep has an effect on memory.', '睡眠会影响记忆。', '影响；效果', '四级核心词'),
  (35, 1, 'effort', '/ˈefət/', '努力', 'make an effort 表示付出努力。', 'Every small effort matters.', '每一点小努力都重要。', '努力', '四级核心词'),
  (36, 1, 'environment', '/ɪnˈvaɪrənmənt/', '环境', 'learning environment 表示学习环境。', 'A quiet environment helps study.', '安静的环境有助于学习。', '环境', '四级核心词'),
  (37, 1, 'experience', '/ɪkˈspɪəriəns/', '经验；经历', 'learning experience 表示学习经历。', 'This experience changed his plan.', '这段经历改变了他的计划。', '经验；经历', '四级核心词'),
  (38, 1, 'include', '/ɪnˈkluːd/', '包括；包含', 'include examples 表示包含例子。', 'The list includes many common words.', '这个列表包含许多常见单词。', '包括；包含', '四级核心词'),
  (39, 1, 'necessary', '/ˈnesəsəri/', '必要的', 'necessary step 表示必要步骤。', 'Daily review is necessary for memory.', '每日复习对记忆是必要的。', '必要的', '四级核心词'),
  (40, 1, 'provide', '/prəˈvaɪd/', '提供', 'provide support 表示提供支持。', 'The app provides useful examples.', '这个应用提供有用例句。', '提供', '四级核心词'),
  (41, 1, 'reason', '/ˈriːzn/', '原因；理由', 'main reason 表示主要原因。', 'What is the reason for the mistake?', '这个错误的原因是什么？', '原因；理由', '四级核心词'),
  (42, 1, 'result', '/rɪˈzʌlt/', '结果；导致', 'as a result 表示结果是。', 'Practice leads to a better result.', '练习会带来更好的结果。', '结果；导致', '四级核心词'),
  (43, 1, 'similar', '/ˈsɪmələ/', '相似的', 'be similar to 表示与某物相似。', 'These two words are similar in meaning.', '这两个词意思相似。', '相似的', '四级核心词'),
  (44, 1, 'simple', '/ˈsɪmpl/', '简单的', 'simple method 表示简单方法。', 'Start with a simple goal.', '从一个简单目标开始。', '简单的', '四级核心词'),
  (45, 1, 'understand', '/ˌʌndəˈstænd/', '理解；明白', 'understand the meaning 表示理解含义。', 'Examples help you understand the word.', '例句帮助你理解单词。', '理解；明白', '四级核心词'),
  (46, 1, 'value', '/ˈvæljuː/', '价值；重视', 'learning value 表示学习价值。', 'This word has practical value.', '这个单词有实际价值。', '价值；重视', '四级核心词'),
  (47, 1, 'possible', '/ˈpɒsəbl/', '可能的', 'as soon as possible 表示尽快。', 'It is possible to finish the task today.', '今天完成任务是可能的。', '可能的', '四级核心词'),
  (48, 1, 'process', '/ˈprəʊses/', '过程；处理', 'learning process 表示学习过程。', 'Memory improves during the review process.', '记忆在复习过程中提升。', '过程；处理', '四级核心词'),
  (49, 1, 'important', '/ɪmˈpɔːtnt/', '重要的', 'important point 表示重点。', 'It is important to review regularly.', '规律复习很重要。', '重要的', '四级核心词'),
  (50, 1, 'volunteer', '/ˌvɒlənˈtɪə/', '志愿者；自愿做', 'volunteer to do 表示自愿做某事。', 'He volunteered to help classmates.', '他自愿帮助同学。', '志愿者；自愿做', '四级核心词'),

  (51, 2, 'assumption', '/əˈsʌmpʃn/', '假设；设想', 'basic assumption 表示基本假设。', 'The argument is based on this assumption.', '这个论证基于这个假设。', '假设；设想', '六级核心词'),
  (52, 2, 'consequence', '/ˈkɒnsɪkwəns/', '结果；后果', 'serious consequence 表示严重后果。', 'Every decision has a consequence.', '每个决定都有后果。', '结果；后果', '六级核心词'),
  (53, 2, 'demonstrate', '/ˈdemənstreɪt/', '证明；展示', 'demonstrate ability 表示展示能力。', 'The data demonstrate the trend.', '数据证明了这个趋势。', '证明；展示', '六级核心词'),
  (54, 2, 'dimension', '/daɪˈmenʃn/', '方面；维度', 'social dimension 表示社会层面。', 'The problem has another dimension.', '这个问题有另一个层面。', '方面；维度', '六级核心词'),
  (55, 2, 'emphasis', '/ˈemfəsɪs/', '强调；重点', 'place emphasis on 表示强调。', 'The course places emphasis on practice.', '这门课强调练习。', '强调；重点', '六级核心词'),
  (56, 2, 'evaluate', '/ɪˈvæljueɪt/', '评估；评价', 'evaluate performance 表示评估表现。', 'We need to evaluate the result.', '我们需要评估结果。', '评估；评价', '六级核心词'),
  (57, 2, 'inevitable', '/ɪnˈevɪtəbl/', '不可避免的', 'inevitable change 表示不可避免的变化。', 'Some mistakes are inevitable at first.', '一开始犯错是不可避免的。', '不可避免的', '六级核心词'),
  (58, 2, 'initiative', '/ɪˈnɪʃətɪv/', '主动性；倡议', 'take the initiative 表示采取主动。', 'She took the initiative to ask questions.', '她主动提问。', '主动性；倡议', '六级核心词'),
  (59, 2, 'maintain', '/meɪnˈteɪn/', '保持；维持', 'maintain balance 表示保持平衡。', 'You should maintain a steady pace.', '你应该保持稳定节奏。', '保持；维持', '六级核心词'),
  (60, 2, 'objective', '/əbˈdʒektɪv/', '客观的；目标', 'objective evidence 表示客观证据。', 'The report gives an objective view.', '报告给出了客观看法。', '客观的；目标', '六级核心词'),
  (61, 2, 'potential', '/pəˈtenʃl/', '潜在的；潜力', 'potential risk 表示潜在风险。', 'The method has great potential.', '这个方法很有潜力。', '潜在的；潜力', '六级核心词'),
  (62, 2, 'priority', '/praɪˈɒrəti/', '优先事项', 'top priority 表示首要任务。', 'Review is our priority today.', '复习是我们今天的优先事项。', '优先事项', '六级核心词'),
  (63, 2, 'relevant', '/ˈreləvənt/', '相关的', 'be relevant to 表示与某事相关。', 'Choose examples relevant to the topic.', '选择和主题相关的例子。', '相关的', '六级核心词'),
  (64, 2, 'restrict', '/rɪˈstrɪkt/', '限制；约束', 'restrict access 表示限制访问。', 'Time may restrict your choices.', '时间可能限制你的选择。', '限制；约束', '六级核心词'),
  (65, 2, 'sustainable', '/səˈsteɪnəbl/', '可持续的', 'sustainable development 表示可持续发展。', 'Build a sustainable study routine.', '建立可持续的学习习惯。', '可持续的', '六级核心词'),
  (66, 2, 'transform', '/trænsˈfɔːm/', '转变；改造', 'transform into 表示转变成。', 'Practice can transform your confidence.', '练习能改变你的信心。', '转变；改造', '六级核心词'),
  (67, 2, 'vary', '/ˈveəri/', '变化；不同', 'vary from person to person 表示因人而异。', 'Learning speed may vary.', '学习速度可能不同。', '变化；不同', '六级核心词'),
  (68, 2, 'welfare', '/ˈwelfeə/', '福利；幸福', 'public welfare 表示公共福利。', 'Education improves social welfare.', '教育提升社会福利。', '福利；幸福', '六级核心词'),
  (69, 2, 'whereas', '/ˌweərˈæz/', '然而；鉴于', '用于对比两个事实。', 'Some prefer reading, whereas others prefer listening.', '有些人喜欢阅读，然而另一些人喜欢听力。', '然而；鉴于', '六级核心词'),
  (70, 2, 'domestic', '/dəˈmestɪk/', '国内的；家庭的', 'domestic market 表示国内市场。', 'Domestic demand is increasing.', '国内需求正在增加。', '国内的；家庭的', '六级核心词'),

  (71, 3, 'abstract', '/ˈæbstrækt/', '抽象的；摘要', 'abstract idea 表示抽象概念。', 'The article begins with an abstract.', '文章以摘要开头。', '抽象的；摘要', '考研核心词'),
  (72, 3, 'academic', '/ˌækəˈdemɪk/', '学术的', 'academic writing 表示学术写作。', 'Academic reading requires patience.', '学术阅读需要耐心。', '学术的', '考研核心词'),
  (73, 3, 'clarify', '/ˈklærəfaɪ/', '澄清；阐明', 'clarify a point 表示阐明观点。', 'The example clarifies the theory.', '这个例子阐明了理论。', '澄清；阐明', '考研核心词'),
  (74, 3, 'coherent', '/kəʊˈhɪərənt/', '连贯的；一致的', 'coherent argument 表示连贯论证。', 'A coherent essay is easier to understand.', '连贯的文章更容易理解。', '连贯的；一致的', '考研核心词'),
  (75, 3, 'comprise', '/kəmˈpraɪz/', '包含；由……组成', '常用主动语态，注意不要误用。', 'The course comprises three parts.', '这门课程包含三个部分。', '包含；由……组成', '考研核心词'),
  (76, 3, 'crucial', '/ˈkruːʃl/', '关键的；至关重要的', 'crucial role 表示关键作用。', 'Vocabulary plays a crucial role in reading.', '词汇在阅读中起关键作用。', '关键的；至关重要的', '考研核心词'),
  (77, 3, 'decline', '/dɪˈklaɪn/', '下降；拒绝', 'decline sharply 表示急剧下降。', 'The rate began to decline.', '这个比率开始下降。', '下降；拒绝', '考研核心词'),
  (78, 3, 'emerge', '/ɪˈmɜːdʒ/', '出现；显现', 'emerge from 表示从……出现。', 'A new problem emerged during the study.', '研究中出现了一个新问题。', '出现；显现', '考研核心词'),
  (79, 3, 'framework', '/ˈfreɪmwɜːk/', '框架；体系', 'theoretical framework 表示理论框架。', 'The framework helps organize ideas.', '这个框架帮助组织观点。', '框架；体系', '考研核心词'),
  (80, 3, 'imply', '/ɪmˈplaɪ/', '暗示；意味着', 'imply that 表示暗示某事。', 'The result implies a deeper problem.', '结果意味着一个更深层问题。', '暗示；意味着', '考研核心词'),
  (81, 3, 'integrate', '/ˈɪntɪɡreɪt/', '整合；结合', 'integrate theory with practice 表示理论结合实践。', 'The app integrates review and practice.', '这个应用整合了复习和练习。', '整合；结合', '考研核心词'),
  (82, 3, 'notion', '/ˈnəʊʃn/', '概念；看法', 'general notion 表示一般概念。', 'The notion is widely accepted.', '这个观念被广泛接受。', '概念；看法', '考研核心词'),
  (83, 3, 'obtain', '/əbˈteɪn/', '获得；取得', 'obtain information 表示获取信息。', 'Researchers obtained useful data.', '研究者获得了有用数据。', '获得；取得', '考研核心词'),
  (84, 3, 'phenomenon', '/fəˈnɒmɪnən/', '现象', 'social phenomenon 表示社会现象。', 'The phenomenon deserves attention.', '这个现象值得关注。', '现象', '考研核心词'),
  (85, 3, 'principle', '/ˈprɪnsəpl/', '原则；原理', 'basic principle 表示基本原则。', 'The principle applies to learning.', '这个原则适用于学习。', '原则；原理', '考研核心词'),
  (86, 3, 'prior', '/ˈpraɪə/', '先前的；优先的', 'prior knowledge 表示先前知识。', 'Prior experience affects understanding.', '先前经验会影响理解。', '先前的；优先的', '考研核心词'),
  (87, 3, 'rational', '/ˈræʃnəl/', '理性的；合理的', 'rational decision 表示理性决定。', 'A rational plan reduces wasted time.', '合理计划能减少时间浪费。', '理性的；合理的', '考研核心词'),
  (88, 3, 'reveal', '/rɪˈviːl/', '揭示；显示', 'reveal a fact 表示揭示事实。', 'The survey reveals a clear trend.', '调查揭示了明显趋势。', '揭示；显示', '考研核心词'),
  (89, 3, 'structure', '/ˈstrʌktʃə/', '结构；组织', 'sentence structure 表示句子结构。', 'Analyze the structure before reading.', '阅读前先分析结构。', '结构；组织', '考研核心词'),
  (90, 3, 'valid', '/ˈvælɪd/', '有效的；合理的', 'valid argument 表示有效论证。', 'The evidence supports a valid conclusion.', '证据支持一个合理结论。', '有效的；合理的', '考研核心词');

ALTER TABLE words AUTO_INCREMENT = 91;
